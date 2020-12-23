//
//  BlissMapper.swift
//  BlissApp
//
//  Created by Rafael Martins on 22/12/20.
//

import Foundation

final class BlissMapper {
//    static func map(from model: BlissLocalModel) -> Dictionary<String, String> {
//        var emojiDictionary = Dictionary<String, String>()
//        emojiDictionary = [model.name: model.link]
//        return emojiDictionary
//
//    }

    static func map(from source: Dictionary<String, String>.Element) -> BlissLocalModel {
        let model = BlissLocalModel()

        model.name = source.key
        model.link = source.value

        return model
    }

    static func map(from source: Dictionary<String, String>) -> BlissLocalModel {
        let model = BlissLocalModel()

        for emoji in source {
            model.name = emoji.key
            model.link = emoji.value
        }

        return model
    }

    static func map(from source: [EmojisModel]) -> BlissLocalModel {
        let model = BlissLocalModel()

        for emoji in source[0].emojis {
            model.name = emoji.key
            model.link = emoji.value
        }

        return model
    }

    static func map(from model: BlissLocalModel) -> EmojisModel {
        var emojiDictionary = Dictionary<String, String>()
        emojiDictionary = [model.name: model.link]
        return EmojisModel(emojis: emojiDictionary)

    }

    static func map(from source: EmojisModel) -> BlissLocalModel {
        let model = BlissLocalModel()

        for emoji in source.emojis {
            model.name = emoji.key
            model.link = emoji.value
        }

        return model
    }
}
