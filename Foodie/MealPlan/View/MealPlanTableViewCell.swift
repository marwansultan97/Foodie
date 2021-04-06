//
//  MealPlanTableViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 2/11/21.
//

import UIKit
import ChameleonFramework

class MealPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealIcon: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 20
        colorView.layer.masksToBounds = false
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowOpacity = 1
        colorView.layer.shadowRadius = 2
        
        mealIcon.layer.cornerRadius = mealIcon.frame.height/2
        mealIcon.layer.shadowColor = UIColor.black.cgColor
        mealIcon.layer.shadowOffset = .zero
        mealIcon.layer.shadowOpacity = 1
        mealIcon.layer.shadowRadius = 1
        
        mealNameLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
