//
//  MealPlanViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/11/21.
//

import UIKit
import SDWebImage
import ChameleonFramework

class MealPlanDayViewController: UIViewController {

    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var caloriesTF: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nutritionsView: UIView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    private let cellIdentifier = "MealPlanTableViewCell"
    private lazy var viewModel: MealPlanViewModel = {
        return MealPlanViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableViewCell()
        configureUI()
        initVM()
    }
    
    //MARK: - ViewModel Binding
    func initVM() {
        
        viewModel.didRecieveMealPlan = { [weak self] in
            guard let self = self else { return }
            guard let mealPlan = self.viewModel.mealPlan else { return }
            self.tableView.reloadData()
            self.caloriesLabel.text = "Calories: \(mealPlan.nutrients.calories)"
            self.carbLabel.text = "Carbohydrates: \(mealPlan.nutrients.carbohydrates)"
            self.proteinLabel.text = "Proteins: \(mealPlan.nutrients.protein)"
            self.fatLabel.text = "Fats: \(mealPlan.nutrients.fat)"
        }
        viewModel.didRecieveErrorMessage = { [weak self] in
            
        }
        viewModel.didRecieveContentAlpha = { [weak self] in
            guard let self = self else { return }
            self.contentView.alpha = self.viewModel.contentAlpha
            self.nutritionsView.alpha = self.viewModel.contentAlpha
        }
        viewModel.didRecieveIsLoading = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        
        
    }
    
    //MARK: - UI Configurations
    func configureUI() {
        title = "Day Meal Plan"
        
        nutritionsView.alpha = 0
        contentView.alpha = 0
        
        caloriesTF.delegate = self
        
        nutritionsView.layer.masksToBounds = false
        nutritionsView.layer.shadowOffset = .zero
        nutritionsView.layer.shadowOpacity = 1
        nutritionsView.layer.shadowColor = UIColor.black.cgColor
        nutritionsView.layer.shadowRadius = 2
        
        filterView.layer.masksToBounds = false
        filterView.layer.shadowOffset = .zero
        filterView.layer.shadowOpacity = 1
        filterView.layer.shadowColor = UIColor.black.cgColor
        filterView.layer.shadowRadius = 2
        filterView.backgroundColor = FlatNavyBlue()
        
        caloriesTF.backgroundColor = .clear
        caloriesTF.textColor = .white
        caloriesTF.attributedPlaceholder = NSAttributedString(string: "Optional...", attributes: [NSAttributedString.Key.foregroundColor : FlatWhite().withAlphaComponent(0.75)])
        
        activityIndicator.color = .black
    }
    

    func configureTableViewCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 270
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func searchBTNTapped(_ sender: UIButton) {
        view.endEditing(true)
        viewModel.getMealPlanDay(calories: caloriesTF.text ?? "")
    }
    

}

//MARK: - TableView & TextField Configurations
extension MealPlanDayViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mealPlan?.meals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MealPlanTableViewCell
        guard let mealPlan = viewModel.mealPlan else { return cell }
        let meal = mealPlan.meals[indexPath.row]
        let url = URL(string:  "https://spoonacular.com/recipeImages/\(meal.id)-556x370.jpg")
        cell.mealIcon.sd_setImage(with: url, completed: nil)
        cell.mealNameLabel.text = meal.title
        cell.timeLabel.text = "\(meal.readyInMinutes) Min"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mealPlan = viewModel.mealPlan else { return }
        let mealID = mealPlan.meals[indexPath.row].id
        let storyboard = UIStoryboard(name: "RecipeContent", bundle: nil)
        let tabbarVC = storyboard.instantiateInitialViewController() as! UITabBarController
        let overviewVC = tabbarVC.viewControllers?.first as? OverviewViewController
        overviewVC?.id = mealID

        navigationController?.pushViewController(tabbarVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        view.endEditing(true)
        viewModel.getMealPlanDay(calories: text)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChars = CharacterSet(charactersIn: "1234567890")
        let textSet = CharacterSet(charactersIn: string)
        return allowedChars.isSuperset(of: textSet)
    }
    
    
    
}
