//
//  MenuItemsSearchViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/10/21.
//

import UIKit
import ChameleonFramework
import SDWebImage

class MenuItemsSearchViewController: UIViewController {

    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let cellIdentifier = "RandomRecipeTableViewCell"
    
    private lazy var viewModel: MenuItemsSearchViewModel = {
        return MenuItemsSearchViewModel()
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/1.5, height: 30))
        searchbar.delegate = self
        searchbar.barTintColor = .black
        if #available(iOS 13.0, *) {
            searchbar.searchTextField.backgroundColor = .black
            searchbar.searchTextField.leftView?.tintColor = FlatWhite()
            searchbar.searchTextField.textColor = FlatWhite()
            searchbar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter meal name...", attributes: [NSAttributedString.Key.foregroundColor : FlatWhite().withAlphaComponent(0.75)])
        } else {
            searchbar.tintColor = .white
            if let textField = searchbar.value(forKey: "searchField") as? UITextField {
                textField.backgroundColor = .black
                textField.leftView?.tintColor = FlatWhite()
                textField.textColor = FlatWhite()
                textField.attributedPlaceholder = NSAttributedString(string: "Enter meal name...", attributes: [NSAttributedString.Key.foregroundColor : FlatWhite().withAlphaComponent(0.75)])
            }
        } 
        searchbar.autocapitalizationType = .none
        searchbar.showsCancelButton = true
        return searchbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.color = .black
        navigationItem.titleView = self.searchBar
        configureTableView()
        initVM()
        
    }
    
    //MARK: - ViewModel Binding
    func initVM() {
        
        viewModel.didRecieveMenuItems = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.didRecieveErrorMessage = { [weak self] in
            guard let self = self else { return }
            let mutableAtt = NSMutableAttributedString(string: "Oops.\n\(self.viewModel.errorMessage!)")
            mutableAtt.setAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor.black], range: NSRange(location: 0, length: 5))
            self.errLabel.attributedText = mutableAtt
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
                self.errLabel.text = ""
            } else {
                self.activityIndicator.stopAnimating()
                self.searchBar.endEditing(true)
            }
        }
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 280
        tableView.estimatedRowHeight = 280
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    

}

//MARK: - TableView & SearchBar Configurations
extension MenuItemsSearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, BackDelegate {
    
    func backButtonTapped() {
        view.alpha = 1
    }
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RandomRecipeTableViewCell
        let menuItem = viewModel.menuItems[indexPath.row]
        let url = URL(string: menuItem.image ?? "")
        cell.recipeImage.sd_setImage(with: url, completed: nil)
        cell.recipeName.text = menuItem.title
        cell.similarRecipesButton.alpha = 0
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.alpha = 0.7
        let menuItemID = viewModel.menuItems[indexPath.row].id
        let vc = UIStoryboard(name: "MenuListItemInformation", bundle: nil).instantiateInitialViewController() as? MenuListItemInformationViewController
        vc?.transitioningDelegate = self
        vc?.delegate = self
        vc?.menuItemID = menuItemID
        vc?.modalPresentationStyle = .custom
        self.present(vc!, animated: true, completion: nil)
        

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.getMenuItems(query: text, pagination: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        if position > contentHeight - scrollViewHeight {
            guard !viewModel.isPaginating else { return }
            viewModel.getMenuItems(query: searchBar.text!, pagination: true)
        }
    }
    
}
