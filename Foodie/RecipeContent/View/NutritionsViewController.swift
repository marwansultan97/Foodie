//
//  NutritionsViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 1/28/21.
//

import UIKit

class NutritionsViewController: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    
    var summary = ""
    
    var recipe: Recipe? {
        didSet {
            guard let summary = recipe?.summary else { return }
            self.summary = summary
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabel()
        
    }
    
    
    func configureLabel() {
        let str = summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        summaryLabel.adjustsFontSizeToFitWidth = true
        summaryLabel.minimumScaleFactor = 0.2
        summaryLabel.text = str
    }
        

}
