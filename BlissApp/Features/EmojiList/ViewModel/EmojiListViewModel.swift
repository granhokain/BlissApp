//
//  EmojiListViewModel.swift
//  BlissApp
//
//  Created by Rafael Martins on 23/12/20.
//

import Foundation
import RxSwift
import RxCocoa

final class EmojiListViewModel {

    private let repository: BlissRepository
    public let items = PublishSubject<[EmojiCatalog]>()

    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    var showError: ((String, String) -> Void)?

    init(repository: BlissRepository = .init()) {
        self.repository = repository
    }

    func fetchEmojiList(update: Bool = false) {
        if !update {
            startLoading?()
        }

        DispatchQueue.main.async {
            self.getEmojiList()
        }

    }

    func getEmojiList() {
        repository.getEmojiList(update: false) { [weak self] result in
            switch result {
            case .success(let emojis):
                self?.endLoading?()
                var productArray = [EmojiCatalog]()
                for emoji in emojis {
                    productArray.append(EmojiCatalog(imageName: emoji.value, name: emoji.key))
                }
                self?.items.onNext(productArray)
                self?.items.onCompleted()
            case .failure(let error):
                self?.endLoading?()
                self?.showError?("Something wrong!", error.localizedDescription)
            }
        }
    }
}
