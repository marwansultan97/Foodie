//
//  HomeViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import UIKit
import AMPopTip
import ChameleonFramework
import SideMenuSwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var popTip: PopTip?
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
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        let boldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black]
        let boldMutableAttributes = NSMutableAttributedString(string: "Hungry?", attributes: boldAttributes)
        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black]
        let normalMutableAttributes = NSMutableAttributedString(string: " Try these deliciuos dishes!", attributes: normalAttributes)
        boldMutableAttributes.append(normalMutableAttributes)
        label.attributedText = boldMutableAttributes
        view.addSubview(label)
        label.center = view.center
        return view
        
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.backgroundColor = .white
        return view
    }()
    
    lazy var footerPaginatingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.backgroundColor = .white
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        ai.startAnimating()
        if #available(iOS 13.0, *) {
            ai.style = .medium
        }
        ai.color = .black
        view.addSubview(ai)
        ai.center = view.center
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initVM()
        configurePopJoke()
        configureNavBar()
        configureSideMenu()
        setupNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        footerView.addSubview(tipButton)
        tipButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        tipButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
    }
    
    //MARK: - SideMenu and Navigation Methods
    
    func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.width - 80
        SideMenuController.preferences.basic.position = .sideBySide
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
        SideMenuController.preferences.animation.shadowColor = UIColor.black
        SideMenuController.preferences.animation.shadowAlpha = 0.5
        
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(goToSearchRecipeName), name: NSNotification.Name.init(rawValue: "SearchRecipeName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToSearchRecipeFilters), name: NSNotification.Name.init(rawValue: "SearchRecipeFilters"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToMenuList), name: NSNotification.Name.init(rawValue: "MenuList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToMenuItemsSearch), name: NSNotification.Name.init(rawValue: "MenuItemsSearch"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToMealPlanDay), name: NSNotification.Name.init(rawValue: "MealPlanDay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToMealPlanWeek), name: NSNotification.Name.init(rawValue: "MealPlanWeek"), object: nil)
    }
    
    @objc func showSideMenu() {
        sideMenuController?.revealMenu()
    }
    
    @objc func goToMealPlanDay() {
        let vc = UIStoryboard(name: "MealPlanDay", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func goToMealPlanWeek() {
        let vc = UIStoryboard(name: "MealPlanWeek", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func goToMenuItemsSearch() {
        let vc = UIStoryboard(name: "MenuItemsSearch", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func goToSearchRecipeName() {
        let vc = UIStoryboard(name: "SearchRecipeName", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func goToSearchRecipeFilters() {
        let vc = UIStoryboard(name: "SearchRecipeFilter", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func goToMenuList() {
        let menuListVC = UIStoryboard(name: "MenuList", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(menuListVC!, animated: true)
    }
    
    
    //MARK: - ViewModel Binding
    func initVM() {
        viewModel.didRecieveRandomRecipe = { [weak self] in
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
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
                self.contentView.alpha = 0
            } else {
                self.activityIndicator.stopAnimating()
                self.contentView.alpha = 1
            }
        }
        viewModel.didRecieveRandomJoke = {
            self.popTip?.text = self.viewModel.randomJoke?.text
        }
        
//        viewModel.getRecipes(pagination: false)
//        viewModel.getJoke()
        
    }
    
    //MARK: - UserInterface Configurations
    
    func configureNavBar() {
        let button = UIBarButtonItem(image: UIImage(named: "SF_line_horizontal_3_decrease_circle_fill"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.leftBarButtonItem = button
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
        
        activityIndicator.color = .black
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = 280
        tableView.estimatedRowHeight = 280
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.setupRefresh()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
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
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.getRecipes(pagination: false)
            self.viewModel.getJoke()
        }
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
        cell.selectionStyle = .none
        cell.configureCell(recipe: recipe)
        cell.delegate = self
        cell.id = recipe.id
        cell.name = recipe.title
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
        tabbarVC.title = "Recipe Details"
        navigationController?.pushViewController(tabbarVC, animated: true)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        popTip?.hide()
        let position = scrollView.contentOffset.y
        let contentHeight = self.tableView.contentSize.height
        let scrollHeight = scrollView.frame.height
        tableView.tableFooterView = viewModel.isPaginating ? self.footerPaginatingView : self.footerView
        guard position > contentHeight + 50 - scrollHeight else { return }
        guard !viewModel.isPaginating else { return }
        viewModel.getRecipes(pagination: true)
        
    }
    
    
}

//MARK: - Similar Button Cell
extension HomeViewController: SimilarRecipeDelegate {
    func similarRecipeTapped(withID id: Int, andName name: String) {
        let storyboard = UIStoryboard(name: "SimilarRecipes", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? SimilarRecipesViewController
        vc?.id = id
        vc?.name = name
        self.navigationController?.pushViewController(vc!, animated: true)
    }


    
}


