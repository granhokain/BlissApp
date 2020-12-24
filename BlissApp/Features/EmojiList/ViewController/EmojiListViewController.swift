//
//  EmojiListViewController.swift
//  BlissApp
//
//  Created by Rafael Martins on 23/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class EmojiListViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: ViewCode
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bag = DisposeBag()
    private let viewModel = EmojiListViewModel()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rx.setDelegate(self).disposed(by: bag)

    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)

        bindTableView()
    }

    //MARK: Bind TableView
    private func bindTableView() {
        tableView.register(UINib(nibName: "EmojiTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")

        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cellId", cellType: EmojiTableViewCell.self)) { (row,item,cell) in
            cell.item = item
        }.disposed(by: bag)

        tableView.rx.modelSelected(EmojiCatalog.self).subscribe(onNext: { item in
            print("SelectedItem: \(item.name)")
        }).disposed(by: bag)

        viewModel.fetchEmojiList()
    }

    //MARK: Bind ViewModel
    private func bindViewModel() {
        viewModel.startLoading = { [unowned self] in
            self.loadingView.startLoading(inView: self.view)
        }

        viewModel.endLoading = { [unowned self] in
            self.loadingView.stopLoading()
        }

        viewModel.showError = { [unowned self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }


}

extension EmojiListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
