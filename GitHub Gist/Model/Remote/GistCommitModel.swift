//
//  GistCommitModel.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/10/01.
//

import Foundation

/// Data model for gists owner
struct GistCommitModel: Codable {

	/// Commit url
	let url: String?

	enum CodingKeys: CodingKey {
		case url
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.url = try container.decodeIfPresent(String.self, forKey: .url)
	}
}
