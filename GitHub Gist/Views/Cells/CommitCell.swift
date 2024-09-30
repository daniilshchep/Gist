//
//  CommitCell.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Cell for commits display
final class CommitCell: UITableViewCell {

	// MARK: - Public Properties

	static let identifier: String = "CommitCell"

	// MARK: - UI components

	private let urlLabel: UILabel = {
		let view = UILabel()
		view.font = .systemFont(ofSize: 20)
		view.numberOfLines = 1
		return view
	}()

	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	/// Config cell content
	func config(url: String) {
		urlLabel.text = url
	}

	// MARK: - Private Methods

	private func setupViews() {
		[urlLabel].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(view)
		}

		NSLayoutConstraint.activate([
			urlLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			urlLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			urlLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			urlLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
		])
	}
}
