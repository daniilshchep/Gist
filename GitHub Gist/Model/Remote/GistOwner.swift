//
//  GistOwner.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import Foundation

/// Data model for gists owner
struct GistOwner: Codable {

	/// Owner name
	let name: String?

	/// Avatar
	let avatar: String?

	enum CodingKeys: String, CodingKey {
		case name = "login"
		case avatar = "avatar_url"
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
	}
}
