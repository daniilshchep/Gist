//
//  GistCell.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import UIKit

/// Cell for gist display
final class GistCell: UITableViewCell {

	// MARK: - Public Properties

	static let identifier: String = "GistCell"

	// MARK: - UI components

	private let titleLabelView: UILabel = {
		let view = UILabel()
		view.font = .systemFont(ofSize: 24)
		view.numberOfLines = 0
		return view
	}()

	private let nameLabelView: UILabel = {
		let view = UILabel()
		view.font = .systemFont(ofSize: 18)
		view.numberOfLines = 1
		view.textColor = .lightGray
		return view
	}()

	private let avatarImageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFill
		view.layer.cornerRadius = 16
		view.backgroundColor = .lightGray
		view.clipsToBounds = true
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
	func config(title: String, name: String, avatar: UIImage?) {
		titleLabelView.text = title
		nameLabelView.text = name
		avatarImageView.image = avatar
	}

	// MARK: - Private Methods

	private func setupViews() {
		[titleLabelView, avatarImageView, nameLabelView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(view)
		}

		NSLayoutConstraint.activate([
			titleLabelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			titleLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			titleLabelView.topAnchor.constraint(equalTo: topAnchor, constant: 32),

			avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			avatarImageView.widthAnchor.constraint(equalToConstant: 32),
			avatarImageView.heightAnchor.constraint(equalToConstant: 32),
			avatarImageView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 16),
			avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),

			nameLabelView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
			nameLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			nameLabelView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
		])
	}
}
