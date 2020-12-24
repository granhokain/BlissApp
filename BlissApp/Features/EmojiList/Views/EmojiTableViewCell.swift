//
//  EmojiTableViewCell.swift
//  BlissApp
//
//  Created by Rafael Martins on 23/12/20.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        holderView.layer.cornerRadius = 10
        productImg.layer.cornerRadius = productImg.frame.width / 2
        productImg.clipsToBounds = true
    }

    var item: EmojiCatalog! {
        didSet {
            setEmojiData()
        }
    }

    private func setEmojiData() {
        let url = URL(string: item.imageName)
        let data = try? Data(contentsOf: url!)
        productImg.image = UIImage(data: data!)
        nameLbl.text = item.name
    }
}
