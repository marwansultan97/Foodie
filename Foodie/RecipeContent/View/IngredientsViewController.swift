//
//  IngredientsViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 1/28/21.
//

import UIKit
import ChameleonFramework
import SDWebImage

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var servingTF: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lineView: UIView!
    
    let cellIdentifier = "IngredientCell"
    var id: Int?
    var ingredients = [ExtendedIngredient]()
    
    var recipe: Recipe? {
        didSet {
            guard recipe != nil else { return }
            self.ingredients = recipe!.extendedIngredients
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    
    //MARK: - UI Configurations
    func configureUI() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        guard let originalServings = recipe?.servings else { return }
        servingTF.text = "\(originalServings) Servings"
        servingTF.delegate = self
        servingTF.textColor = .black
        
        segmentControl.backgroundColor = .lightGray
        segmentControl.selectedSegmentTintColor = .white
        let attributesNormal = [NSAttributedString.Key.foregroundColor : UIColor.black]
        segmentControl.setTitleTextAttributes(attributesNormal, for: .normal)
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 80)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    //MARK: - TableView Configurations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! IngredientTableViewCell
        let ingredient = ingredients[indexPath.row]
        if servingTF.text == "0" {
            let servingsToDisplay = Double(1)
            cell.configureIngredientsCell(ingredient: ingredient, segmentIndex: segmentControl.selectedSegmentIndex, totalServings: recipe!.servings, servingsToDisplay: servingsToDisplay)
        } else {
            let servingsToDisplay = Double(servingTF.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
            cell.configureIngredientsCell(ingredient: ingredient, segmentIndex: segmentControl.selectedSegmentIndex, totalServings: recipe!.servings, servingsToDisplay: servingsToDisplay!)
        }
        
        return cell
    }

    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    

}

//MARK: - TextField Configurations
extension IngredientsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            self.tableView.reloadData()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if servingTF.text == "" || servingTF.text == "0" || servingTF.text == "1" {
            servingTF.text = "1 Serving"
        } else {
            servingTF.text! += " Servings"
        }
        
        UIView.animate(withDuration: 0.3) {
            self.servingTF.textColor = .black
            self.lineView.backgroundColor = .black
            self.lineView.alpha = 0.5
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        servingTF.text = servingTF.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        UIView.animate(withDuration: 0.3) {
            self.servingTF.textColor = .blue
            self.lineView.backgroundColor = .blue
            self.lineView.alpha = 1
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChars = CharacterSet(charactersIn: "0123456789")
        let charSet = CharacterSet(charactersIn: string)
        return allowedChars.isSuperset(of: charSet)
    }
    
}
