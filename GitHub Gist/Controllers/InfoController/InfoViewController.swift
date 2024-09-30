//
//  InfoViewController.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/28.
//

import UIKit

/// Controller for info screen
final class InfoViewController: UIViewController {

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

	private let topInfoContainerView: UIView = {
		let view = UIView()

		view.layer.cornerRadius = 16
		view.layer.borderWidth = 1
		view.layer.borderColor = UIColor.lightGray.cgColor

		return view
	}()

	private let filesLabelView: UILabel = {
		let view = UILabel()
		view.font = .systemFont(ofSize: 24)
		view.numberOfLines = 0
		view.text = "Files"
		return view
	}()

	private lazy var filesTableView: UITableView = {
		let view = UITableView()

		view.dataSource = filesCollectionViewManager
		view.delegate = filesCollectionViewManager
		view.backgroundColor = .clear
		view.register(FileCell.self, forCellReuseIdentifier: FileCell.identifier)
		view.tableFooterView = filesTableViewLoadingActivityIndicatorView

		return view
	}()

	private let filesTableViewLoadingActivityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .large)
		view.hidesWhenStopped = true
		return view
	}()

	private let commitsLabelView: UILabel = {
		let view = UILabel()
		view.font = .systemFont(ofSize: 24)
		view.numberOfLines = 0
		view.text = "Commits"
		return view
	}()

	private lazy var commitsTableView: UITableView = {
		let view = UITableView()

		view.dataSource = commitsCollectionViewManager
		view.delegate = commitsCollectionViewManager
		view.backgroundColor = .clear
		view.register(CommitCell.self, forCellReuseIdentifier: CommitCell.identifier)
		view.tableFooterView = commitsTableViewLoadingActivityIndicatorView

		return view
	}()

	private let commitsTableViewLoadingActivityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .large)
		view.hidesWhenStopped = true
		return view
	}()

	// MARK: - Private Properties

	private let viewModel: InfoViewModelProtocol
	private let gist: GistRepresentableModel

	private lazy var filesCollectionViewManager: InfoViewControllerFilesTableViewManager = {
		let manager = InfoViewControllerFilesTableViewManager()
		manager.delegate = self
		return manager
	}()

	private lazy var commitsCollectionViewManager: InfoViewControllerCommitsTableViewManager = {
		let manager = InfoViewControllerCommitsTableViewManager()
		manager.delegate = self
		return manager
	}()

	// MARK: - Init

	init(
		with viewModel: InfoViewModelProtocol,
		gist: GistRepresentableModel
	) {
		self.viewModel = viewModel
		self.gist = gist

		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupGistInfo()
		setupViews()
		loadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.navigationController?.setNavigationBarHidden(false, animated: animated)
	}

	// MARK: - Private Methods

	private func setupGistInfo() {
		titleLabelView.text = gist.title
		nameLabelView.text = gist.name
		avatarImageView.image = gist.avatar
	}

	private func setupViews() {
		view.backgroundColor = .systemBackground

		[
			topInfoContainerView,
			filesLabelView,
			filesTableView,
			commitsLabelView,
			commitsTableView
		].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}

		NSLayoutConstraint.activate([
			topInfoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			topInfoContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			topInfoContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

			filesLabelView.topAnchor.constraint(equalTo: topInfoContainerView.bottomAnchor, constant: 16),
			filesLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
			filesLabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),

			filesTableView.topAnchor.constraint(equalTo: filesLabelView.bottomAnchor, constant: 8),
			filesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			filesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			filesTableView.heightAnchor.constraint(equalToConstant: 256),

			commitsLabelView.topAnchor.constraint(equalTo: filesTableView.bottomAnchor, constant: 16),
			commitsLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
			commitsLabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),

			commitsTableView.topAnchor.constraint(equalTo: commitsLabelView.bottomAnchor, constant: 8),
			commitsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
			commitsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			commitsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])

		[
			titleLabelView,
			nameLabelView,
			avatarImageView
		].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			topInfoContainerView.addSubview(view)
		}

		NSLayoutConstraint.activate([
			titleLabelView.leadingAnchor.constraint(equalTo: topInfoContainerView.leadingAnchor, constant: 16),
			titleLabelView.trailingAnchor.constraint(equalTo: topInfoContainerView.trailingAnchor, constant: -16),
			titleLabelView.topAnchor.constraint(equalTo: topInfoContainerView.topAnchor, constant: 16),

			avatarImageView.leadingAnchor.constraint(equalTo: topInfoContainerView.leadingAnchor, constant: 16),
			avatarImageView.widthAnchor.constraint(equalToConstant: 32),
			avatarImageView.heightAnchor.constraint(equalToConstant: 32),
			avatarImageView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 16),
			avatarImageView.bottomAnchor.constraint(equalTo: topInfoContainerView.bottomAnchor, constant: -16),

			nameLabelView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
			nameLabelView.trailingAnchor.constraint(equalTo: topInfoContainerView.trailingAnchor, constant: -16),
			nameLabelView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
		])
	}

	private func loadData() {
		filesTableViewLoadingActivityIndicatorView.startAnimating()
		commitsTableViewLoadingActivityIndicatorView.startAnimating()

		viewModel.loadFiles(for: gist) { [weak self] files in
			guard let self else { return }

			DispatchQueue.main.async {
				self.filesCollectionViewManager.files = files
				self.filesTableView.reloadData()
				self.filesTableViewLoadingActivityIndicatorView.stopAnimating()
			}
		}

		viewModel.loadCommits(for: gist) {  [weak self] commits in
			guard let self else { return }

			DispatchQueue.main.async {
				self.commitsCollectionViewManager.commits = commits
				self.commitsTableView.reloadData()
				self.commitsTableViewLoadingActivityIndicatorView.stopAnimating()
			}
		}
	}
}

// MARK: - InfoViewControllerFilesTableViewManagerDelegate conformance

extension InfoViewController: InfoViewControllerFilesTableViewManagerDelegate {
	
	func didSelectFile(_ file: GistRepresentableFile) {
		let fileViewController = FileViewController()
		fileViewController.setupContent(with: file.content)
		present(fileViewController, animated: true)
	}
}

// MARK: - InfoViewControllerCommitsTableViewManagerDelegate conformance

extension InfoViewController: InfoViewControllerCommitsTableViewManagerDelegate {

	func didSelectCommit(_ commit: GistRepresentableCommit) {
		guard let url = URL(string: commit.url ?? "") else { return }

		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
}
