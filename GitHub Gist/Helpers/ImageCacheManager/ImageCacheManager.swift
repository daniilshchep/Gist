//
//  ImageCacheManager.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import UIKit

/// Protocol for image caching manager
protocol ImageCacheManagerProtocol {

	/// Get image from cache if exists
	func getImage(for key: String) -> UIImage?

	/// Save image to cache
	func saveImage(_ image: UIImage, for key: String)
}

/// Manager for image caching
final class ImageCacheManager: ImageCacheManagerProtocol {

	// MARK: - Private Properties

	private let cache = NSCache<NSString, UIImage>()

	// MARK: - Public Methods

	func getImage(for key: String) -> UIImage? {
		return cache.object(forKey: key as NSString)
	}

	func saveImage(_ image: UIImage, for key: String) {
		cache.setObject(image, forKey: key as NSString)
	}
}
