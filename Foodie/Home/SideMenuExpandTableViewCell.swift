//
//  SideMenuExpandTableViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 2/8/21.
//

import UIKit

class SideMenuExpandTableViewCell: UITableViewCell {

    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
