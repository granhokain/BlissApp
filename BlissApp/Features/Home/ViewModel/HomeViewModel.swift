//
//  HomeViewModel.swift
//  BlissApp
//
//  Created by Rafael Martins on 21/12/20.
//

import Foundation
import UIKit

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

    func getEmojiList(update: Bool = false) {
        if !update {
            startLoading?()
        }

        repository.getEmojiList(update: update) { [weak self] result in
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
        repository.getEmojiList(update: false) { [weak self] result in
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

    func showEmojiList(vc: HomeViewController) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "EmojiList", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "EmojiListViewController")
        newViewController.modalPresentationStyle = .fullScreen
        vc.present(newViewController, animated: true, completion: nil)
    }
}
