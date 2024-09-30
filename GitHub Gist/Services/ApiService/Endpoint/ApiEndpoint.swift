//
//  ApiEndpoint.swift
//  GitHub Gist
//
//  Created by Daniil Shchepkin on 2024/09/26.
//

/// Endpoint for API requests
struct ApiEndpoint {

	/// Path (without base part)
	let path: String

	/// Method type
	let method: ApiRequestMethod

	/// Query params
	let queryParams: [String: String]?
}
