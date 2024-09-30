//
//  JsonParser.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import Foundation

/// Protocol for JSON data parser
protocol JsonParserProtocol {

	/// Decode JSON data
	func decodeData<T: Codable>(_ data: Data) throws -> T
}

/// Parser for JSON data
final class JsonParser: JsonParserProtocol {

	// MARK: - Public Methods

	func decodeData<T: Codable>(_ data: Data) throws -> T {
		try JSONDecoder().decode(T.self, from: data)
	}
}
