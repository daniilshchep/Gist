//
//  ImageService.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import UIKit

/// Protocol for image service
protocol ImageServiceProtocol {

	/// Download image from specific url
	func downloadImage(from url: String) async -> UIImage?
}

/// Service for image related stuff
final class ImageService: ImageServiceProtocol {

	func downloadImage(from url: String) async -> UIImage? {
		guard let imageUrl = URL(string: url) else {
			return nil
		}

		do {
			let (data, _) = try await URLSession.shared.data(from: imageUrl)

			return UIImage(data: data)
		} catch {
			return nil
		}
	}
}
