//
//  SideMenuTableViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 2/8/21.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.layer.masksToBounds = false
        titleLabel.layer.shadowColor = UIColor.white.cgColor
        titleLabel.layer.shadowRadius = 1
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = .zero
        backgroundColor = .clear
        tintColor = .white
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
