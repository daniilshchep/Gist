//
//  GistRepresentableModel.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import UIKit

/// Data model for gists representation
struct GistRepresentableModel {

	/// Gist id
	let id: String

	/// Gist title
	let title: String

	/// Gist owner name
	let name: String

	/// Gist owner avatar
	let avatar: UIImage?
}
