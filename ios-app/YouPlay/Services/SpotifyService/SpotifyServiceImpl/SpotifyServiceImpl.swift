//
//  SpotifyServiceImpl.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import Foundation

enum CredentialError: Error {
    case missingCredentials(message: String)
    case invalidCredentials(message: String)
}

class SpotifyServiceImpl: SpotifyService {
    private var networkService: NetworkService

    static let shared = SpotifyServiceImpl()
    private init() {
        networkService = NetworkServiceImpl(baseUrl: SPOTIFY_BASE_API_URL)
    }

    /// `getAccessToken` retrieves a valid Spotify access token (Bearer) to make API requests with.
    func getAccessToken() async -> String? {
        do {
            let (clientId, clientSecret) = try loadSpotifyCredentials()
            let accessToken = try await authenticateWithSpotify(clientId: clientId, clientSecret: clientSecret)

            return accessToken
        } catch {
            print("DEBUG: unable to retrieve access token", error)
        }

        return nil
    }

    /// `search` searches for songs based on some input text.
    ///
    /// Note: for now, we are only searching for songs by name.
    func search(text: String) async -> SpotifySearchResponse? {
        let queryParams: [String: String] = [
            "type": "track", // comma separated list (ex. "artist,track")
            "q": text
        ]

        do {
            let accessToken = await getAccessToken()
            let data = try await networkService.request(method: .get,
                                                        endpoint: "/search",
                                                        queryParams: queryParams,
                                                        body: nil,
                                                        bearerToken: accessToken)

            let results = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
            return results
        } catch {
            print("DEBUG: error while searching for song", error)
        }

        return nil
    }

    /// `loadSpotifyCredentials` retrives relevant Spotify credentials from a `SpotifyService.plist` file.
    private func loadSpotifyCredentials() throws -> (clientId: String, clientSecret: String) {
        guard let path = Bundle.main.path(forResource: "SpotifyService", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path)
        else {
            throw CredentialError.missingCredentials(message: "Missing SpotifyService.plist credentials!")
        }

        do {
            let plistData = try PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: String]

            guard let clientId = plistData?["CLIENT_ID"],
                  let clientSecret = plistData?["CLIENT_SECRET"]
            else {
                throw CredentialError.missingCredentials(message: "CLIENT_ID or CLIENT_SECRET was not found!")
            }

            return (clientId, clientSecret)
        } catch {
            throw CredentialError.invalidCredentials(message: "Unable to read Spotify credentials from plist \(error)")
        }
    }

    /// `authenticateWithSpotify` fetches an Bearer access token to interact with API endpoints.
    private func authenticateWithSpotify(clientId: String, clientSecret: String) async throws -> String? {
        let bodyParameters = "grant_type=client_credentials"
        let postData = bodyParameters.data(using: .utf8)

        guard let url = URL(string: SPOTIFY_TOKEN_URL) else {
            print("DEBUG: invalid SPOTIFY_TOKEN_URL found.")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let credentials = "\(clientId):\(clientSecret)".data(using: .utf8)?.base64EncodedString() ?? ""
        request.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        request.httpBody = postData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            guard let accessToken = json?["access_token"] as? String else {
                print("DEBUG: access_token not found within JSON response.")
                return nil
            }

            return accessToken
        } catch {
            print("DEBUG: error retrieving access token", error)
            throw error
        }
    }
}
