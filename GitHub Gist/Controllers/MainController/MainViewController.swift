//
//  MainViewController.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import UIKit

/// Controller for main screen
final class MainViewController: UIViewController {

	// MARK: - UI components

	private let loadingActivityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .large)
		view.hidesWhenStopped = true
		return view
	}()

	private lazy var gistTableView: UITableView = {
		let view = UITableView()
		view.delegate = self
		view.dataSource = self
		view.backgroundColor = .clear
		view.tableFooterView = gistTableViewLoadingActivityIndicatorView
		view.refreshControl = gistTableViewRefreshControl
		view.register(GistCell.self, forCellReuseIdentifier: GistCell.identifier)
		return view
	}()

	private lazy var gistTableViewRefreshControl: UIRefreshControl = {
		let control = UIRefreshControl()
		control.addTarget(self, action: #selector(refreshGistTableView), for: .valueChanged)
		return control
	}()

	private let gistTableViewLoadingActivityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .large)
		view.hidesWhenStopped = true
		return view
	}()

	// MARK: - Private Properties

	private let viewModel: MainViewModelProtocol

	private var gists = [GistRepresentableModel]()
	private var page: Int = 1
	private var isLoading: Bool = false

	// MARK: - Init

	init(with viewModel: MainViewModelProtocol) {
		self.viewModel = viewModel

		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		loadingActivityIndicatorView.startAnimating()
		loadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}

	// MARK: - Private Methods

	private func setupViews() {
		view.backgroundColor = .systemBackground

		[loadingActivityIndicatorView, gistTableView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}

		NSLayoutConstraint.activate([
			loadingActivityIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			loadingActivityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
			loadingActivityIndicatorView.widthAnchor.constraint(equalToConstant: 32),
			loadingActivityIndicatorView.heightAnchor.constraint(equalToConstant: 32),

			gistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			gistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			gistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			gistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	private func loadData(isRefresh: Bool = false) {
		guard !isLoading else { return }

		isLoading = true

		if isRefresh {
			self.gists.removeAll()
			self.page = 1
		}

		viewModel.loadData(page: self.page) { [weak self] data in
			guard let self else { return }

			page += 1

			self.gists.append(contentsOf: data)
			self.isLoading = false

			DispatchQueue.main.async {
				self.loadingActivityIndicatorView.stopAnimating()
				self.gistTableViewLoadingActivityIndicatorView.stopAnimating()
				self.gistTableViewRefreshControl.endRefreshing()
				self.gistTableView.reloadData()
			}
		}
	}

	@objc
	private func refreshGistTableView() {
		loadData(isRefresh: true)
	}

	private func openInfoViewController(with gist: GistRepresentableModel) {
		let jsonParser = JsonParser()
		let apiService = ApiService(jsonParser: jsonParser)
		let imageService = ImageService()
		let imageCacheManager = ImageCacheManager()
		let gistManager = GistManager(
			apiService: apiService,
			imageService: imageService,
			imageCacheManager: imageCacheManager
		)
		let infoViewModel = InfoViewModel(gistManager: gistManager)
		let infoViewController = InfoViewController(with: infoViewModel, gist: gist)
		navigationController?.pushViewController(infoViewController, animated: true)
	}
}

// MARK: - UITableViewDelegate & UITableViewDataSource conformance

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		return gists.count
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: GistCell.identifier,
			for: indexPath
		) as? GistCell else {
			return UITableViewCell()
		}

		if (0..<gists.count).contains(indexPath.row) {
			let gist = gists[indexPath.row]
			
			cell.config(
				title: gist.title,
				name: gist.name,
				avatar: gist.avatar
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

		openInfoViewController(with: gists[indexPath.row])
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height

		if offsetY > contentHeight - scrollView.frame.size.height && !gists.isEmpty {
			gistTableViewLoadingActivityIndicatorView.startAnimating()
			loadData()
		}
	}
}
