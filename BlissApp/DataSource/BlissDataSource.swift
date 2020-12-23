//
//  BlissDataSource.swift
//  BlissApp
//
//  Created by Rafael Martins on 21/12/20.
//

import Foundation

protocol BlissDataSource {
    func getEmoji(completion: @escaping EmojiCallback)
}
