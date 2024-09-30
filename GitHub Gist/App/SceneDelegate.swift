//
//  SceneDelegate.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		window = UIWindow(windowScene: windowScene)

		let jsonParser = JsonParser()
		let apiService = ApiService(jsonParser: jsonParser)
		let imageService = ImageService()
		let imageCacheManager = ImageCacheManager()
		let gistManager = GistManager(
			apiService: apiService,
			imageService: imageService,
			imageCacheManager: imageCacheManager
		)
		let mainViewModel = MainViewModel(gistManager: gistManager)
		let mainViewController = MainViewController(with: mainViewModel)
		window?.rootViewController = UINavigationController(rootViewController: mainViewController)
		window?.makeKeyAndVisible()
	}

	func sceneDidDisconnect(_ scene: UIScene) {

	}

	func sceneDidBecomeActive(_ scene: UIScene) {

	}

	func sceneWillResignActive(_ scene: UIScene) {

	}

	func sceneWillEnterForeground(_ scene: UIScene) {

	}

	func sceneDidEnterBackground(_ scene: UIScene) {

	}
}
