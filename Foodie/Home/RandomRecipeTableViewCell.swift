//
//  RandomRecipeTableViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import UIKit
import ChameleonFramework
import SDWebImage

protocol SimilarRecipeDelegate {
    func similarRecipeTapped(withID id: Int, andName name: String)
}

class RandomRecipeTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var similarRecipesButton: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    var delegate: SimilarRecipeDelegate?
    var id: Int?
    var name: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
                
        recipeImage.layer.cornerRadius = recipeImage.frame.height / 2
        recipeImage.layer.shadowColor = UIColor.black.cgColor
        recipeImage.layer.shadowOffset = .zero
        recipeImage.layer.shadowOpacity = 1
        recipeImage.layer.shadowRadius = 1
        
        colorView.backgroundColor = FlatSkyBlueDark()
        colorView.layer.masksToBounds = false
        colorView.layer.cornerRadius = 30
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowOpacity = 1
        colorView.layer.shadowRadius = 2
        
        recipeName.adjustsFontSizeToFitWidth = true
        
        similarRecipesButton.layer.cornerRadius = similarRecipesButton.frame.height / 2
        similarRecipesButton.layer.borderWidth = 1
        similarRecipesButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(recipe: Recipe) {
        recipeName.text = recipe.title
        
        timeLabel.text = "\(recipe.readyInMinutes) Min"
        guard let imageString = recipe.image else { return }
        let url = URL(string: imageString)
        recipeImage.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func similarRecipesBTNTapped(_ sender: UIButton) {
        self.delegate?.similarRecipeTapped(withID: self.id ?? 0, andName: name ?? "")
    }
    
}
