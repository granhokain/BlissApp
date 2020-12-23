//
//  BlissRemoteDataSource.swift
//  BlissApp
//
//  Created by Rafael Martins on 21/12/20.
//

import Foundation
import Alamofire

protocol BlissRemoteDataSource: BlissDataSource {}

final class BlissRemoteSource: BlissRemoteDataSource {
    private let getEmojiURL = "https://api.github.com/emojis"

    func getEmoji(completion: @escaping EmojiCallback) {
        let url = URL(string: getEmojiURL)!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            if let data = data {
                typealias emojisTyped = Dictionary<String, String>
                if let emojis = try? JSONDecoder().decode(emojisTyped.self, from: data) {
                    DispatchQueue.main.async { completion(.success(emojis)) }
                } else {
                    DispatchQueue.main.async { completion(.failure(RuntimeError("Unable to fetch response from API"))) }
                }
            }


        }.resume()
    }
}
