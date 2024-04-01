//
//  Network.swift
//  YouPlay
//
//  Created by Sebastian on 3/24/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum RequestError: Error {
    case invalidURL
    case serializationError
    case unknownError
}

protocol NetworkService {
    var BASE_URL: String { get }
    func request(method: HTTPMethod,
                 endpoint: String,
                 queryParams: [String: String]?,
                 body: [String: Any]?,
                 bearerToken: String?) async throws -> Data
}

/// A generic service to perform HTTP requests.
class NetworkServiceImpl: NetworkService {
    let BASE_URL: String

    init(baseUrl: String) {
        self.BASE_URL = baseUrl
    }

    /// Performs an asynchronous HTTP request.
    ///
    /// - Parameters:
    ///   - method: The HTTP method for the request.
    ///   - endpoint: The endpoint to which the request is made.
    ///   - queryParams: Optional query parameters to be included in the request URL.
    ///   - body: Optional request body parameters to be included in the request.
    ///   - bearerToken: Optional bearer token for authentication.
    /// - Returns: The response data from the server.
    /// - Throws: An error if the request encounters any issues, such as invalid URL, serialization error, or failure to execute the request.
    func request(method: HTTPMethod,
                 endpoint: String,
                 queryParams: [String: String]? = nil,
                 body: [String: Any]? = nil,
                 bearerToken: String? = nil) async throws -> Data
    {
        guard let url = URL(string: "\(BASE_URL)\(endpoint)") else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw RequestError.serializationError
            }
        }

        if let queryParams = queryParams {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

            if let fullURL = components?.url {
                request.url = fullURL
            }
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
