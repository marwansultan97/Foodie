//
//  SimilarRecipesViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/8/21.
//

import UIKit
import SDWebImage
import ChameleonFramework

class SimilarRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    private let cellIdentifier = "RandomRecipeTableViewCell"
    
    var id: Int?
    var name: String?
    
    lazy var viewModel: SimilarRecipesViewModel = {
        return SimilarRecipesViewModel(id: id!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.color = .black
        initVM()
        configureTableView()
    }

    //MARK: - ViewModel Binding
    func initVM() {
        viewModel.didRecieveSimilarRecipe = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.didRecieveErrorMessage = { [weak self] in
            print(self?.viewModel.errorMessage)
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
        
        viewModel.getRecipes()
        
        
    }
    
    //MARK: - TableView Configurations
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = 280
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.similarRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RandomRecipeTableViewCell
        let recipe = viewModel.similarRecipes[indexPath.row]
        let url = URL(string: "https://spoonacular.com/recipeImages/\(recipe.id)-556x370.jpg")
        cell.recipeImage.sd_setImage(with: url, completed: nil)
        cell.recipeName.text = recipe.title
        cell.similarRecipesButton.alpha = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipeID = viewModel.similarRecipes[indexPath.row].id
        let tabbar = UIStoryboard(name: "RecipeContent", bundle: nil).instantiateInitialViewController() as? UITabBarController
        let overviewVC = tabbar?.viewControllers?.first as? OverviewViewController
        overviewVC?.id = recipeID
        self.navigationController?.pushViewController(tabbar!, animated: true)
        
    }
    


}
