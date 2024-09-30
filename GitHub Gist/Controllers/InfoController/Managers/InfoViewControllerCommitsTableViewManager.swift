//
//  InfoViewControllerCommitsTableViewManager.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Delegate for commits collection view manager
protocol InfoViewControllerCommitsTableViewManagerDelegate {

	/// Commit cell has been selected
	func didSelectCommit(_ commit: GistRepresentableCommit)
}

/// UITableViewDelegate, UITableViewDataSource conformance class for commits collection view
final class InfoViewControllerCommitsTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {

	var commits = [GistRepresentableCommit]()
	var delegate: InfoViewControllerCommitsTableViewManagerDelegate?

	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		return commits.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: CommitCell.identifier,
			for: indexPath
		) as? CommitCell else {
			return UITableViewCell()
		}

		if (0..<commits.count).contains(indexPath.row) {
			let commit = commits[indexPath.row]

			cell.config(url: commit.url ?? "Unknow commit")

			return cell
		}

		return UITableViewCell()
	}

	func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		tableView.deselectRow(at: indexPath, animated: true)

		delegate?.didSelectCommit(commits[indexPath.row])
	}
}
