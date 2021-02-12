//
//  MenuListItemsViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/10/21.
//

import UIKit
import SDWebImage

class MenuListItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "RandomRecipeTableViewCell"
    var query: String? {
        didSet {
            guard query != nil else { return }
            viewModel = MenuListItemsViewModel(query: query!)
        }
    }
    
    var navTitle: String?
    
    private lazy var viewModel: MenuListItemsViewModel = {
        return MenuListItemsViewModel(query: self.query!)
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = navTitle
        activityIndicator.color = .black
        configureTableView()
        initVM()
    }
    
    //MARK: - ViewModel Binding
    func initVM() {
        viewModel.didRecieveListItems = { [weak self] in
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
        
        viewModel.getMenuItems(pagination: false)
        
    }
    
    //MARK: - TableView Configurations
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 280
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RandomRecipeTableViewCell
        let imageURL = URL(string: viewModel.listItems[indexPath.row].image ?? "")
        cell.recipeImage.sd_setImage(with: imageURL, completed: nil)
        cell.recipeName.text = viewModel.listItems[indexPath.row].title
        cell.recipeName.adjustsFontSizeToFitWidth = true
        cell.similarRecipesButton.alpha = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemID = viewModel.listItems[indexPath.row].id
        let vc = UIStoryboard(name: "MenuListItemInformation", bundle: nil).instantiateInitialViewController() as? MenuListItemInformationViewController
        view.alpha = 0.7
        vc?.transitioningDelegate = self
        vc?.modalPresentationStyle = .custom
        vc?.delegate = self
        vc?.menuItemID = itemID
        self.present(vc!, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        if position > contentHeight - scrollViewHeight {
            guard !viewModel.isPaginating else { return }
            print("get")
            viewModel.getMenuItems(pagination: true)
            
        }
        
    }
    
}

//MARK: - Half Size Modal Presenting & Dismissing Delegate
extension MenuListItemsViewController: UIViewControllerTransitioningDelegate, BackDelegate {
    
    func backButtonTapped() {
        self.view.alpha = 1
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}


class HalfSizePresentationController : UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: containerView!.bounds.height/3, width: containerView!.bounds.width, height: containerView!.bounds.height/4 * 3)
    }
    
}
