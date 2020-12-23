//
//  BlissLocalDataSource.swift
//  BlissApp
//
//  Created by Rafael Martins on 22/12/20.
//

import Foundation
import RealmSwift

protocol BlissLocalDataSource: BlissDataSource {
    func saveEmojis(emojis: [EmojisModel])
    func deleteEmoji()
}

final class BlissLocalSource: BlissLocalDataSource {
    private let realm: Realm?

    init(realm: Realm? = try? .init()) {
        self.realm = realm
    }

    func getEmoji(completion: @escaping EmojiCallback) {
        if let emojisModel = realm?.objects(BlissLocalModel.self) {
            let emojis = emojisModel.map { BlissMapper.map(from: $0) }
            let conversion = Array(emojis)
            var values = [String: String]()
            for value in conversion {
                guard let emojiValue = value.emojis.first?.value, let key = value.emojis.first?.key else {
                    return
                }
                values.updateValue(emojiValue, forKey: key)
            }
            if !conversion.isEmpty {
                completion(.success(values))
            }else {
                completion(.success([:]))
            }
        } else {
            completion(.failure(RuntimeError("Unable to fetch prices from local source")))
        }
    }

    func saveEmojis(emojis: [EmojisModel]) {
        deleteEmoji()

        try? realm?.write {
            for emoji in emojis {
                for emoj in emoji.emojis {
                    let models = BlissMapper.map(from: emoj)
                    realm?.add(models)
                }
            }
        }
    }

    func deleteEmoji() {
        try? realm?.write {
            realm?.deleteAll()
        }
    }
}
