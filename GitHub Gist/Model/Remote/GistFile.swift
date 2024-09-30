//
//  GistFile.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/28.
//

/// Data model for gists files
struct GistFile: Codable {

	/// File name
	let name: String

	/// File content url
	let url: String

	enum CodingKeys: String, CodingKey {
		case name = "filename"
		case url = "raw_url"
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: .name)
		self.url = try container.decode(String.self, forKey: .url)
	}
}
