//
//  SpotifyServiceImpl.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import Foundation

class SpotifyServiceImpl: SpotifyService {
    private init() {}
    static let shared = SpotifyServiceImpl()

    func loadSpotifyCredentials() throws -> (clientId: String?, clientSecret: String?) {
        guard let path = Bundle.main.path(forResource: "SpotifyService", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path)
        else {
            throw CredentialError.missingCredentials(message: "Missing SpotifyService.plist credentials!")
        }

        do {
            let plistData = try PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: String]

            let clientId = plistData?["CLIENT_ID"]
            let clientSecret = plistData?["CLIENT_Secret"]
            return (clientId, clientSecret)
        } catch {
            throw CredentialError.invalidCredentials(message: "Unable to read Spotify credentials from plist \(error)")
        }
    }

    func authenticateWithSpotify(clientId: String, clientSecret: String) {
        let bodyParameters = "grant_type=client_credentials"
        let postData = bodyParameters.data(using: .utf8)

        guard let url = URL(string: spotifyTokenURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let credentials = "\(clientId):\(clientSecret)".data(using: .utf8)?.base64EncodedString() ?? ""
        request.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String
                {
                    print("Access Token: \(accessToken)")
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }
}

enum CredentialError: Error {
    case missingCredentials(message: String)
    case invalidCredentials(message: String)
}
