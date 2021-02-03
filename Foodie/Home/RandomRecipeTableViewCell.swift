//
//  RandomRecipeTableViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import UIKit
import SDWebImage

class RandomRecipeTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var obacityView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(16)
        let separatorView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - separatorHeight, width: screenSize.width, height: separatorHeight))
        separatorView.backgroundColor = UIColor.systemBackground
        self.addSubview(separatorView)
        recipeImage.layer.cornerRadius = 15
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(recipe: Recipe) {
        recipeName.text = recipe.title
        recipeName.adjustsFontSizeToFitWidth = true
        guard let imageString = recipe.image else { return }
        let url = URL(string: imageString)
        recipeImage.sd_setImage(with: url, completed: nil)
    }
    
    
}
