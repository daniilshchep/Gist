//
//  ApiEndpointFactory.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

import Foundation

/// Protocol for endpoint factory
protocol ApiEndpointFactoryProtocol {

	/// Endpoint for specific gist request
	static func makeGistEndpoint(by id: String) -> ApiEndpoint

	/// Endpoint for gists request
	static func makeGistListEndpoint(page: String) -> ApiEndpoint

	/// Endpoint for gists commits request
	static func makeGistCommitsListEndpoint(by id: String) -> ApiEndpoint
}

/// Endpoint factory
final class ApiEndpointFactory: ApiEndpointFactoryProtocol {

	static func makeGistEndpoint(by id: String) -> ApiEndpoint {
		ApiEndpoint(
			path: "gists/\(id)",
			method: .get,
			queryParams: nil
		)
	}

	static func makeGistListEndpoint(page: String) -> ApiEndpoint {
		ApiEndpoint(
			path: "gists",
			method: .get,
			queryParams: ["page": page]
		)
	}

	static func makeGistCommitsListEndpoint(by id: String) -> ApiEndpoint {
		ApiEndpoint(
			path: "gists/\(id)/commits",
			method: .get,
			queryParams: nil
		)
	}
}
