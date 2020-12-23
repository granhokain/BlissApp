//
//  HomeViewModel.swift
//  BlissApp
//
//  Created by Rafael Martins on 21/12/20.
//

import Foundation

final class HomeViewModel {
    private let repository: BlissRepository

    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    var showFirstEmoji: ((String) -> Void)?
    var showNewEmoji: ((String) -> Void)?
    var showError: ((String, String) -> Void)?

    init(repository: BlissRepository = .init()) {
        self.repository = repository
    }

    func fetchMarketPrice(update: Bool = false) {
//        if !update {
//            startLoading?()
//        }

        repository.fetchMarketPrice(update: update) { [weak self] result in
            switch result {
            case .success(let emojis):
                self?.endLoading?()
                guard let emojiUrl = emojis.first?.value else {
                    return
                }
                 self?.showFirstEmoji?(emojiUrl)
            case .failure(let error):
                self?.endLoading?()
                self?.showError?("Something wrong!", error.localizedDescription)
            }
        }
    }

    func getRandomEmoji() {
        repository.fetchMarketPrice(update: false) { [weak self] result in
            switch result {
            case .success(let emojis):
                self?.endLoading?()
                let randomInt = Int.random(in: 0..<emojis.count)
                let index = emojis.index(emojis.startIndex, offsetBy: randomInt)
                let emojiUrl = emojis.values[index]
                self?.showNewEmoji?(emojiUrl)
            case .failure(let error):
                self?.endLoading?()
                self?.showError?("Something wrong!", error.localizedDescription)
            }
        }
    }
}
