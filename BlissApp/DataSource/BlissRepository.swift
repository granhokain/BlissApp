//
//  BlissRepository.swift
//  BlissApp
//
//  Created by Rafael Martins on 21/12/20.
//

import Foundation

typealias EmojiCallback = (Result<[String: String], Error>) -> Void

final class BlissRepository {
    private let localSource: BlissLocalDataSource
    private let remoteSource: BlissRemoteDataSource

    init(
        localSource: BlissLocalDataSource = BlissLocalSource(),
        remoteSource: BlissRemoteDataSource = BlissRemoteSource()
    ) {
        self.localSource = localSource
        self.remoteSource = remoteSource
    }

    func getEmojiList(update: Bool, completion: @escaping EmojiCallback) {
        guard !update else {
            fetchFromRemote(completion: completion)
            return
        }

        localSource.getEmoji { [weak self] result in
            switch result {
            case let .success(localEmojis):
                if !localEmojis.isEmpty {
                    completion(.success(localEmojis))
                } else {
                    self?.fetchFromRemote(completion: completion)
                }
            case .failure:
                self?.fetchFromRemote(completion: completion)
            }
        }
    }

    func fetchFromRemote(completion: @escaping EmojiCallback) {
        remoteSource.getEmoji { [weak self] result in
            switch result {
            case let .success(remoteEmojis):
                let emojis = EmojisModel(emojis: remoteEmojis)
                self?.localSource.saveEmojis(emojis: [emojis])

                self?.localSource.getEmoji(completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
