//
//  InfoViewModel.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/28.
//

/// Protocol for info controller's ViewModel
protocol InfoViewModelProtocol {

	/// Load gist files
	func loadFiles(
		for gist: GistRepresentableModel,
		_ completion: @escaping ([GistRepresentableFile]) -> Void
	)

	/// Load gist commits
	func loadCommits(
		for gist: GistRepresentableModel,
		_ completion: @escaping ([GistRepresentableCommit]) -> Void
	)
}

/// ViewModel for info controller
final class InfoViewModel: InfoViewModelProtocol {

	// MARK: - Private Properties

	private let gistManager: GistManagerProtocol

	// MARK: - Init

	init(gistManager: GistManagerProtocol) {
		self.gistManager = gistManager
	}

	// MARK: - Public Methods

	func loadFiles(
		for gist: GistRepresentableModel,
		_ completion: @escaping ([GistRepresentableFile]) -> Void
	) {
		Task {
			let files = await gistManager.getFiles(for: gist.id)
			completion(files)
		}
	}

	func loadCommits(
		for gist: GistRepresentableModel,
		_ completion: @escaping ([GistRepresentableCommit]) -> Void
	) {
		Task {
			let commits = await gistManager.getCommits(for: gist.id)
			completion(commits)
		}
	}
}
