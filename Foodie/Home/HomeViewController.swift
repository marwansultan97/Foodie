//
//  HomeViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import UIKit
import AMPopTip
import ChameleonFramework
import DropDown

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var popTip: PopTip?
    var searchMenu = DropDown()
    private let cellIdentifier = "RandomRecipeTableViewCell"
    
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    
    lazy var tipButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let att = NSAttributedString(string: "Did you know?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.orange, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        button.setAttributedTitle(att, for: .normal)
        button.addTarget(self, action: #selector(handleTrivia), for: .touchUpInside)
        button.tintColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        let boldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        let boldMutableAttributes = NSMutableAttributedString(string: "Hungry?", attributes: boldAttributes)
        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        let normalMutableAttributes = NSMutableAttributedString(string: " Try these deliciuos dishes!", attributes: normalAttributes)
        boldMutableAttributes.append(normalMutableAttributes)
        label.attributedText = boldMutableAttributes
        view.addSubview(label)
        label.center = view.center
        return view
        
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        return view
    }()
    
    lazy var footerPaginatingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        ai.startAnimating()
        ai.style = .medium
        view.addSubview(ai)
        ai.center = view.center
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initVM()
        configureTableView()
        configurePopJoke()
        configureNavBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        footerView.addSubview(tipButton)
        tipButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        tipButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
    }
    
    @objc func showSearchMenu() {
        self.searchMenu.show()
    }
    
    
    
    //MARK: - ViewModel Binding
    func initVM() {
        viewModel.didRecieveRandomRecipe = { [weak self] in
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
        viewModel.didRecieveRandomJoke = {
            self.popTip?.text = self.viewModel.randomJoke?.text
        }
        
        viewModel.getRecipes(pagination: false)
        viewModel.getJoke()
        
    }
    
    //MARK: - UserInterface Configurations
    
    
    func configureNavBar() {
        let button = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(showSearchMenu))
        navigationItem.rightBarButtonItem = button
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = FlatNavyBlue()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
        
        searchMenu.anchorView = navigationItem.rightBarButtonItem
        searchMenu.dataSource = ["Search Recipes by Name","Search Recipes With Filters"]
        searchMenu.backgroundColor = FlatBlue()
        searchMenu.textColor = .white
        searchMenu.selectionBackgroundColor = FlatBlueDark()
        searchMenu.bottomOffset = CGPoint(x: 0, y: (navigationController?.navigationBar.frame.height)!)
        searchMenu.selectionBackgroundColor = UIColor.white.darken(byPercentage: 0.1)
        searchMenu.selectionAction = { [weak self] (index,item) in
            guard let self = self else { return }
            if index == 0 {
                let vc = SearchRecipeNameViewController.storyboardInstance()
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                let vc = SearchRecipeFilterViewController.storyboardInstance()
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 280
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func configurePopJoke() {
        popTip = PopTip()
        popTip?.entranceAnimation = .scale
        popTip?.textColor = .white
        popTip?.bubbleColor = .systemOrange
        popTip?.offset = 0
        popTip?.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        popTip?.shouldDismissOnTap = true
    }
    
    
    @objc func handleTrivia() {
        self.popTip?.show(text: popTip?.text ?? "Nothing is here", direction: .up, maxWidth: 250, in: tableView.tableFooterView!, from: tipButton.frame)
    }
    
    
    //MARK: - TableView Configurations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.randomRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RandomRecipeTableViewCell
        let recipe = viewModel.randomRecipes[indexPath.row]
        cell.configureCell(recipe: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        popTip?.hide()
        let recipeSelected = viewModel.randomRecipes[indexPath.row].id
        let storyboard = UIStoryboard(name: "RecipeContent", bundle: nil)
        let tabbarVC = storyboard.instantiateInitialViewController() as! UITabBarController
        let overviewVC = tabbarVC.viewControllers?.first as? OverviewViewController
        overviewVC?.id = recipeSelected

        navigationController?.pushViewController(tabbarVC, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = self.tableView.contentSize.height
        let scrollHeight = scrollView.frame.height
        tableView.tableFooterView = viewModel.isPaginating ? self.footerPaginatingView : self.footerView
        if position > contentHeight + 50 - scrollHeight {
            guard !viewModel.isPaginating else { return }
            viewModel.getRecipes(pagination: true)
        }
        
    }
    

    static func storyboardInstance() -> HomeViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        return storyboard.instantiateInitialViewController() as? HomeViewController
    }

}


