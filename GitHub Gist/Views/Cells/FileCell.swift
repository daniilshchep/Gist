//
//  FileCell.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/30.
//

import UIKit

/// Cell for files display
final class FileCell: UITableViewCell {

	// MARK: - Public Properties

	static let identifier: String = "FileCell"

	// MARK: - UI components

	private let nameLabelView: UILabel = {
		let view = UILabel()
		view.font = .systemFont(ofSize: 20)
		view.numberOfLines = 0
		return view
	}()

	private let contentLabelView: UILabel = {
		let view = UILabel()
		view.font = .systemFont(ofSize: 14)
		view.numberOfLines = 5
		view.lineBreakMode = .byTruncatingTail
		view.textColor = .lightGray
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
	func config(name: String, content: String) {
		nameLabelView.text = name
		contentLabelView.text = content
	}

	// MARK: - Private Methods

	private func setupViews() {
		[nameLabelView, contentLabelView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(view)
		}

		NSLayoutConstraint.activate([
			nameLabelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			nameLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			nameLabelView.topAnchor.constraint(equalTo: topAnchor, constant: 16),

			contentLabelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			contentLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			contentLabelView.topAnchor.constraint(equalTo: nameLabelView.bottomAnchor, constant: 8),
			contentLabelView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
		])
	}
}
