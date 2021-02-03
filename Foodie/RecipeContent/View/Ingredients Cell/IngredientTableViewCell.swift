//
//  IngredientTableViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 1/29/21.
//

import UIKit
import SDWebImage

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureIngredientsCell(ingredient: ExtendedIngredient, segmentIndex: Int, totalServings: Int, servingsToDisplay: Double) {
        let totalServingsDouble = Double(totalServings)
        
        let url = URL(string: "https://spoonacular.com/cdn/ingredients_100x100/" + String(ingredient.image ?? ""))
        ingredientImage.sd_setImage(with: url, completed: nil)
        if segmentIndex == 0 {
            let amountPerServing = ingredient.measures.us.amount / totalServingsDouble
            ingredientName.text = "\(amountPerServing * servingsToDisplay) \(ingredient.measures.us.unitLong) " + ingredient.originalName
        } else {
            let amountPerServing = ingredient.measures.metric.amount / totalServingsDouble
            ingredientName.text = "\(amountPerServing * servingsToDisplay) \(ingredient.measures.metric.unitLong) " + ingredient.originalName
        }
        
    }
    
    
    func configureEquipmentsCell(equipment: Ent) {
        let url = URL(string: "https://spoonacular.com/cdn/equipment_100x100/" + String(equipment.image))
        ingredientImage.sd_setImage(with: url, completed: nil)
        ingredientName.text = equipment.name
    }
    
}
