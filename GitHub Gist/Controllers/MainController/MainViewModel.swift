//
//  MainViewModel.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import Foundation

/// Protocol for main controller's ViewModel
protocol MainViewModelProtocol {

	/// Load data for list
	func loadData(
		page: Int,
		_ completion: @escaping ([GistRepresentableModel]) -> Void
	)
}

/// ViewModel for main controller
final class MainViewModel: MainViewModelProtocol {

	// MARK: - Private Properties

	private let gistManager: GistManagerProtocol

	// MARK: - Init

	init(gistManager: GistManagerProtocol) {
		self.gistManager = gistManager
	}

	// MARK: - Public Methods

	func loadData(
		page: Int,
		_ completion: @escaping ([GistRepresentableModel]) -> Void
	) {
		Task {
			let data = await gistManager.getGists(page: page)
			completion(data)
		}
	}
}
