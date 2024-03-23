//
//  SpotifyServiceImpl.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import Foundation

func loadSpotifyCredentials() -> (clientId: String?, clientSecret: String?) {
    guard let path = Bundle.main.path(forResource: "SpotifyService", ofType: "plist"),
          let xml = FileManager.default.contents(atPath: path) else {
        return (nil, nil)
    }

    do {
        if let plistData = try PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: AnyObject] {
            let clientId = plistData["CLIENT_ID"] as? String
            let clientSecret = plistData["CLIENT_Secret"] as? String
            return (clientId, clientSecret)
        }
    } catch {
        print(error)
    }
    return (nil, nil)
}

func authenticateWithSpotify(clientId: String, clientSecret: String) {
    let tokenURL = "https://accounts.spotify.com/api/token"
    let bodyParameters = "grant_type=client_credentials"
    let postData = bodyParameters.data(using: .utf8)

    guard let url = URL(string: tokenURL) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let credentials = "\(clientId):\(clientSecret)".data(using: .utf8)?.base64EncodedString() ?? ""
    request.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error ?? "Unknown error")
            return
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let accessToken = json["access_token"] as? String {
                print("Access Token: \(accessToken)")
                // Use the access token to make a test API request or proceed with your application logic
            }
        } catch {
            print(error)
        }
    }

    task.resume()
}
