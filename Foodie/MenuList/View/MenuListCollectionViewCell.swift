//
//  MenuListCollectionViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 2/9/21.
//

import UIKit
import ChameleonFramework

class MenuListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 8)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1
        
    }

}
