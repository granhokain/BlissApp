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
    var presentedVC: UIViewController?

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        bindViewModel()
        viewModel.getEmojiList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.imgTitle.image = UIImage(named: "Bug")
    }

    //MARK: Actions
    @IBAction func changeImage(_ sender: Any) {
        viewModel.getRandomEmoji()
    }

    @IBAction func showEmojisList(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "EmojiList", bundle: nil)
        let presentedVC = storyBoard.instantiateViewController(withIdentifier: "EmojiListViewController")
        presentedVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain,
                                                                       target: self,
                                                                       action: #selector(didTapCloseButton(_:)))
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }

    @IBAction func btnSearch(_ sender: Any) {
        futureImplementations()
    }

    @IBAction func btnShowAvatarList(_ sender: Any) {
        futureImplementations()
    }

    @IBAction func btnShowAppleRepos(_ sender: Any) {
        futureImplementations()
    }

    //MARK: Functions
    @objc func didTapCloseButton(_ sender: Any) {
        if let presentedVC = presentedViewController {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            presentedVC.view.window!.layer.add(transition, forKey: kCATransition)
        }

        dismiss(animated: false, completion: nil)

        presentedVC = nil
    }

    func futureImplementations() {
        let alert = UIAlertController(title: "What's next", message: "This feature will be implemented soon.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

extension UIViewController {

    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, pushing: Bool, completion: (() -> Void)? = nil) {

        if pushing {

            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            viewControllerToPresent.modalPresentationStyle = .fullScreen
            self.present(viewControllerToPresent, animated: false, completion: completion)

        } else {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }

    }

}

