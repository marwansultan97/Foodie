//
//  MealPlanWeekCollectionViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 2/11/21.
//

import UIKit
import ChameleonFramework
import SDWebImage

class MealPlanWeekCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.backgroundColor = FlatSkyBlueDark()
        colorView.layer.cornerRadius = 20
        colorView.layer.masksToBounds = false
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowOpacity = 1
        colorView.layer.shadowRadius = 2
        
        mealImageView.layer.cornerRadius = mealImageView.frame.height/2
        mealImageView.layer.shadowColor = UIColor.black.cgColor
        mealImageView.layer.shadowOffset = .zero
        mealImageView.layer.shadowOpacity = 1
        mealImageView.layer.shadowRadius = 1
        
        mealNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureCell(meal: MealWeek) {
        mealNameLabel.text = meal.title
        let url = URL(string:  "https://spoonacular.com/recipeImages/\(meal.id)-556x370.jpg")
        mealImageView.sd_setImage(with: url, completed: nil)
        timeLabel.text = ": \(meal.readyInMinutes) Min"
    }

}
