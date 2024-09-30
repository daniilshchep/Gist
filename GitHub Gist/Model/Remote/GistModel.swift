//
//  GistModel.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

/// Data model for gists
struct GistModel: Codable {

	/// Gist id
	let id: String

	/// Gist title
	let title: String?

	/// Gist owner
	let owner: GistOwner?

	/// Gist files
	let files: [String: GistFile]

	enum CodingKeys: String, CodingKey {
		case id
		case title = "description"
		case owner
		case files
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(String.self, forKey: .id)
		self.title = try container.decodeIfPresent(String.self, forKey: .title)
		self.owner = try container.decodeIfPresent(GistOwner.self, forKey: .owner)
		self.files = try container.decode([String : GistFile].self, forKey: .files)
	}
}
