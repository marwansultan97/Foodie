//
//  SearchRecipeIDViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/1/21.
//

import UIKit
import ChameleonFramework
import SDWebImage

class SearchRecipeNameViewController: UIViewController {

    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "RandomRecipeTableViewCell"
    
    private lazy var viewModel: SearchRecipeNameViewModel = {
        return SearchRecipeNameViewModel()
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/1.5, height: 30))
        searchbar.delegate = self
        searchbar.barTintColor = FlatNavyBlue()
        if #available(iOS 13.0, *) {
            searchbar.searchTextField.leftView?.tintColor = FlatWhite()
            searchbar.searchTextField.textColor = FlatWhite()
            searchbar.searchTextField.backgroundColor = FlatNavyBlue().darken(byPercentage: 0.1)
            searchbar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter recipe name...", attributes: [NSAttributedString.Key.foregroundColor : FlatWhite().withAlphaComponent(0.75)])
        } else {
            
        }
        searchbar.autocapitalizationType = .none
        searchbar.showsCancelButton = true
        return searchbar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVM()
        configureNavBar()
        configureTableView()
        
        
    }
    
    //MARK: - ViewModel Binding
    func initVM() {
        
        viewModel.didRecieveRecipeElements = { [weak self] in
            self?.tableView.reloadData()
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
                self.searchBar.endEditing(true)
            }
        }
        
        
    }
    
    //MARK: - UI Configurations
    func configureNavBar() {
        navigationItem.titleView = self.searchBar
        activityIndicator.color = .black
    }
    

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 280
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    

}

//MARK: - TableView and SearchBar Configurations
extension SearchRecipeNameViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipeElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RandomRecipeTableViewCell
        let recipeElement = viewModel.recipeElements[indexPath.row]
        let url = URL(string: "https://spoonacular.com/recipeImages/\(recipeElement.id)-556x370.jpg")
        cell.recipeImage.sd_setImage(with: url, completed: nil)
        cell.recipeName.text = recipeElement.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipeElement = viewModel.recipeElements[indexPath.row].id
        let storyboard = UIStoryboard(name: "RecipeContent", bundle: nil)
        let tabbarVC = storyboard.instantiateInitialViewController() as! UITabBarController
        let overviewVC = tabbarVC.viewControllers?.first as? OverviewViewController
        overviewVC?.id = recipeElement
        navigationController?.pushViewController(tabbarVC, animated: true)

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.getData(query: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    
}
