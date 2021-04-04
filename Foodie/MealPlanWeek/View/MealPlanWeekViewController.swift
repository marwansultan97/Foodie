//
//  MealPlanWeekViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/11/21.
//

import UIKit
import ChameleonFramework

class MealPlanWeekViewController: UIViewController {

    
    
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var caloriesTF: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "MealPlanWeekTableViewCell"
    
    private lazy var viewModel: MealPlanWeekViewModel = {
        return MealPlanWeekViewModel()
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
            self.tableView.reloadData()
        }
        viewModel.didRecieveErrorMessage = { [weak self] in
            guard let self = self else { return }
            self.errLabel.text = self.viewModel.errorMessage
            self.activityIndicator.stopAnimating()
            self.contentView.alpha = 0

        }
        viewModel.didRecieveContentAlpha = { [weak self] in
            guard let self = self else { return }
            self.contentView.alpha = self.viewModel.contentAlpha
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
        title = "Week Meal Plan"
        
        caloriesTF.delegate = self
        
        contentView.alpha = 0

        filterView.layer.masksToBounds = false
        filterView.layer.shadowOffset = .zero
        filterView.layer.shadowOpacity = 1
        filterView.layer.shadowColor = UIColor.black.cgColor
        filterView.layer.shadowRadius = 2
        filterView.backgroundColor = FlatNavyBlue()
        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
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
        tableView.rowHeight = 320
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func searchBTNTapped(_ sender: UIButton) {
        view.endEditing(true)
        viewModel.getMealPlanDay(calories: caloriesTF.text ?? "")
    }
    

}

//MARK: - TableView & TextField Configurations
extension MealPlanWeekViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CollectionViewItemSelectionDelegate {
    
    //MARK: - Meal Selection and navigate to Recipe Content
    func didSelect(id: Int) {
        let storyboard = UIStoryboard(name: "RecipeContent", bundle: nil)
        let tabbarVC = storyboard.instantiateInitialViewController() as! UITabBarController
        let overviewVC = tabbarVC.viewControllers?.first as? OverviewViewController
        overviewVC?.id = id
        navigationController?.pushViewController(tabbarVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MealPlanWeekTableViewCell
        cell.delegate = self
        guard let mealPlan = viewModel.mealPlan else { return cell }
        if indexPath.row == 0 {
            cell.meals = mealPlan.week.saturday.meals
            cell.configureCell(day: mealPlan.week.saturday)
            cell.dayLabel.text = "SaturDay"
            
        } else if indexPath.row == 1{
            cell.meals = mealPlan.week.sunday.meals
            cell.configureCell(day: mealPlan.week.sunday)
            cell.dayLabel.text = "Sunday"

        } else if indexPath.row == 2{
            cell.meals = mealPlan.week.monday.meals
            cell.configureCell(day: mealPlan.week.monday)
            cell.dayLabel.text = "Monday"

        } else if indexPath.row == 3{
            cell.meals = mealPlan.week.tuesday.meals
            cell.configureCell(day: mealPlan.week.tuesday)
            cell.dayLabel.text = "Tuesday"

        } else if indexPath.row == 4{
            cell.meals = mealPlan.week.wednesday.meals
            cell.configureCell(day: mealPlan.week.wednesday)
            cell.dayLabel.text = "Wednesday"

        } else if indexPath.row == 5{
            cell.meals = mealPlan.week.thursday.meals
            cell.configureCell(day: mealPlan.week.thursday)
            cell.dayLabel.text = "Thursday"

        } else if indexPath.row == 6{
            cell.meals = mealPlan.week.friday.meals
            cell.configureCell(day: mealPlan.week.friday)
            cell.dayLabel.text = "Friday"

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
