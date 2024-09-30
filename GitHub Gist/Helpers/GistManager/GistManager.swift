//
//  GistManager.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import UIKit

/// Protocol for gist manager
protocol GistManagerProtocol {

	/// Get the list of gists at specific page
	func getGists(page: Int) async -> [GistRepresentableModel]

	/// Get the list of gist files
	func getFiles(for id: String) async -> [GistRepresentableFile]

	/// Get the list of gist commits
	func getCommits(for id: String) async -> [GistRepresentableCommit]
}

/// Manager for gists
final class GistManager: GistManagerProtocol {

	// MARK: - Private Properties

	private let apiService: ApiServiceProtocol
	private let imageService: ImageServiceProtocol
	private let imageCacheManager: ImageCacheManagerProtocol

	// MARK: - Init

	init(
		apiService: ApiServiceProtocol,
		imageService: ImageServiceProtocol,
		imageCacheManager: ImageCacheManagerProtocol
	) {
		self.apiService = apiService
		self.imageService = imageService
		self.imageCacheManager = imageCacheManager
	}

	// MARK: - Public Methods

	func getGists(page: Int) async -> [GistRepresentableModel] {
		let endpoint = ApiEndpointFactory.makeGistListEndpoint(page: String(page))
		do {
			let gists: [GistModel] = try await apiService.sendRequest(to: endpoint) ?? []

			var result: [GistRepresentableModel] = []

			for gist in gists {
				await result.append(convertToRepresentableModel(gist: gist))
			}
			return result
		} catch {
			return []
		}
	}

	func getFiles(for id: String) async -> [GistRepresentableFile] {
		if let gist = await getGist(by: id) {
			do {
				var files = [GistRepresentableFile]()
				try gist.files.values.forEach { file in
					if let url = URL(string: file.url) {
						files.append(
							GistRepresentableFile(
								name: file.name,
								content: try String(contentsOf: url, encoding: .utf8)
							)
						)
					}
				}
				return files
			} catch {
				return []
			}
		}

		return []
	}

	func getCommits(for id: String) async -> [GistRepresentableCommit] {
		let endpoint = ApiEndpointFactory.makeGistCommitsListEndpoint(by: id)

		do {
			guard let commits: [GistCommitModel] = try await apiService.sendRequest(to: endpoint) else {
				return []
			}

			return commits.map { GistRepresentableCommit(url: $0.url) }
		} catch {
			return []
		}
	}

	// MARK: - Private Methods

	private func getGist(by id: String) async -> GistModel? {
		let endpoint = ApiEndpointFactory.makeGistEndpoint(by: id)
		do {
			guard let gist: GistModel = try await apiService.sendRequest(to: endpoint) else {
				return nil
			}

			return gist
		} catch {
			return nil
		}
	}

	private func convertToRepresentableModel(gist: GistModel) async -> GistRepresentableModel {
		let title = gist.title ?? ""
		let name = gist.owner?.name ?? "Unknown user"
		let avatarURL = gist.owner?.avatar ?? ""

		var avatarImage: UIImage?
		if let image = imageCacheManager.getImage(for: avatarURL) {
			avatarImage = image
		} else {
			avatarImage = await imageService.downloadImage(from: avatarURL)

			if let avatarImage {
				imageCacheManager.saveImage(avatarImage, for: avatarURL)
			}
		}

		return GistRepresentableModel(
			id: gist.id,
			title: title.isEmpty ? "Gist without title" : title,
			name: name,
			avatar: avatarImage
		)
	}
}
