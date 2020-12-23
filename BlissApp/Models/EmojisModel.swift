//
//  EmojisModel.swift
//  BlissApp
//
//  Created by Rafael Martins on 22/12/20.
//

import Foundation

struct EmojisModel: Decodable {
    var emojis = Dictionary<String, String>()

    init(emojis: Dictionary<String, String>) {
        self.emojis = emojis
    }

    enum CodingKeys: String, CodingKey {
        case emojis = "x"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        emojis = try container.decode(Dictionary<String, String>.self, forKey: .emojis)
    }
}
