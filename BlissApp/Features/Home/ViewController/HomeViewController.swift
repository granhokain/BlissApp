//
//  HomeViewController.swift
//  BlissApp
//
//  Created by Rafael Martins on 21/12/20.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var imgTitle: UIImageView!

    @IBOutlet weak var btnRandomEmojis: UIButton! {
        didSet {
            btnRandomEmojis.setTitle("RANDOM EMOJI", for: .normal)
        }
    }

    @IBOutlet weak var btnEmojisList: UIButton! {
        didSet {
            btnEmojisList.setTitle("EMOJIS LIST", for: .normal)
        }
    }

    @IBOutlet weak var txtSearch: UITextField! {
        didSet {
            txtSearch.backgroundColor = .white
            let imageView = UIImageView()
            let image = UIImage(named: "search")
            imageView.image = image
            txtSearch.leftView = imageView
            txtSearch.leftViewMode = UITextField.ViewMode.always
        }
    }

    @IBOutlet weak var btnSearch: UIButton! {
        didSet {
            btnSearch.setTitle("SEARCH", for: .normal)
        }
    }

    @IBOutlet weak var btnAvatarList: UIButton! {
        didSet {
            btnAvatarList.setTitle("AVATARS LIST", for: .normal)
        }
    }

    @IBOutlet weak var btnAppleRepos: UIButton! {
        didSet {
            btnAppleRepos.setTitle("APPLE REPOS", for: .normal)
        }
    }

    //MARK: ViewCode
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let viewModel = HomeViewModel()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        bindViewModel()
        viewModel.fetchMarketPrice()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.imgTitle.image = UIImage(named: "Bug")
    }

    @IBAction func changeImage(_ sender: Any) {
        viewModel.getRandomEmoji()
    }

    @IBAction func showEmojisList(_ sender: Any) {
    }

    //MARK: Bind ViewModel
    private func bindViewModel() {
        viewModel.startLoading = { [unowned self] in
            self.loadingView.startLoading(inView: self.view)
        }

        viewModel.endLoading = { [unowned self] in
            self.loadingView.stopLoading()
        }

        viewModel.showFirstEmoji = { [unowned self] emojiUrl in
            self.imgTitle.image = UIImage(named: "Bug")
        }

        viewModel.showNewEmoji = { [unowned self] emojiUrl in
            let url = URL(string: emojiUrl)
            let data = try? Data(contentsOf: url!)
            self.imgTitle.image = UIImage(data: data!)
        }

        viewModel.showError = { [unowned self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

