//
//  FileViewController.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/30.
//

import UIKit

/// Controller for file content screen
final class FileViewController: UIViewController {

	// MARK: - UI components

	private let contentTextView: UITextView = {
		let view = UITextView()
		view.font = .systemFont(ofSize: 24)
		return view
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
	}

	// MARK: - Public Methods

	/// Setup controller content
	func setupContent(with text: String) {
		contentTextView.text = text
	}

	// MARK: - Private Methods

	private func setupViews() {
		view.backgroundColor = .systemBackground

		[contentTextView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}

		NSLayoutConstraint.activate([
			contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
			contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
		])
	}
}
