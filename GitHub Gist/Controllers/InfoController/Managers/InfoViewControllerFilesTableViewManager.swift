//
//  InfoViewControllerFilesTableViewManager.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Delegate for files collection view manager
protocol InfoViewControllerFilesTableViewManagerDelegate {

	/// File cell has been selected
	func didSelectFile(_ file: GistRepresentableFile)
}

/// UITableViewDelegate, UITableViewDataSource conformance class for files collection view
final class InfoViewControllerFilesTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {

	var files = [GistRepresentableFile]()
	var delegate: InfoViewControllerFilesTableViewManagerDelegate?

	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		return files.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: FileCell.identifier,
			for: indexPath
		) as? FileCell else {
			return UITableViewCell()
		}

		if (0..<files.count).contains(indexPath.row) {
			let file = files[indexPath.row]

			cell.config(
				name: file.name,
				content: file.content
			)

			return cell
		}

		return UITableViewCell()
	}

	func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		tableView.deselectRow(at: indexPath, animated: true)

		delegate?.didSelectFile(files[indexPath.row])
	}
}
