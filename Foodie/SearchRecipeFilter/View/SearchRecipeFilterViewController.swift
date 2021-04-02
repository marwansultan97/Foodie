//
//  SearchRecipeFilterViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/1/21.
//

import UIKit
import DropDown
import ChameleonFramework

class SearchRecipeFilterViewController: UIViewController {

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cuisineButton: UIButton!
    @IBOutlet weak var dietButton: UIButton!
    @IBOutlet weak var mealTypeButton: UIButton!
    @IBOutlet weak var readyTimeButton: UIButton!
    @IBOutlet weak var ingredientsTF: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    private let cellIdentifier = "RandomRecipeTableViewCell"
    var isCollapsed = false
    var url: URLComponents?
    var cuisineDropDown = DropDown()
    var dietDropDown = DropDown()
    var mealTypesDropDown = DropDown()
    var timeDropDown = DropDown()
    
    private lazy var addFiltersButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        button.setTitle("Set Filters", for: .normal)
        button.setImage(UIImage(named: "SF_plus_square_on_square_fill"), for: .normal)
        button.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerPaginationView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        footerView.addSubview(ai)
        ai.startAnimating()
        if #available(iOS 13.0, *) {
            ai.style = .medium
        }
        
        ai.color = .black
        ai.center = footerView.center
        return footerView
    }()
    
    private lazy var viewModel: SearchRecipeFilterViewModel = {
        return SearchRecipeFilterViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDropDown()
        configureURL()
        configureButtons()
        configureTableView()
        initVM()
    }
    
    //MARK: - ViewModel Binding
    func initVM() {
        
        viewModel.didRecieveRecipeElements = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.didRecieveErrorMessage = { [weak self] in
            print(self?.viewModel.errorMessage!)
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
    
    //MARK: - URL Configurations
    func configureURL() {
        self.url = URLComponents(string: Endpoints.complexSearch.url)
        url?.queryItems = [
            URLQueryItem(name: "apiKey", value: MyConstants.shared.apiKey), //0
            URLQueryItem(name: "cuisine", value: ""),  // 1
            URLQueryItem(name: "diet", value: ""), // 2
            URLQueryItem(name: "type", value: ""), // 3
            URLQueryItem(name: "maxReadyTime", value: "1000"), // 4
            URLQueryItem(name: "includeIngredients", value: ""), // 5
            URLQueryItem(name: "offset", value: "0"), // 6
            URLQueryItem(name: "sort", value: "popularity"), // 7
            URLQueryItem(name: "number", value: "5") // 8
        ]
    }
    
    //MARK: - UI Configurations
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = 280
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func configureButtons() {
        readyTimeButton.backgroundColor = FlatNavyBlue().darken(byPercentage: 0.2)
        readyTimeButton.layer.cornerRadius = 15
        
        dietButton.backgroundColor = FlatNavyBlue().darken(byPercentage: 0.2)
        dietButton.layer.cornerRadius = 15
        
        cuisineButton.backgroundColor = FlatNavyBlue().darken(byPercentage: 0.2)
        cuisineButton.layer.cornerRadius = 15
        
        mealTypeButton.backgroundColor = FlatNavyBlue().darken(byPercentage: 0.2)
        mealTypeButton.layer.cornerRadius = 15
    }
    
    func configureUI() {
        ingredientsTF.delegate = self
        ingredientsTF.backgroundColor = .clear
        ingredientsTF.textColor = .white
        ingredientsTF.attributedPlaceholder = NSAttributedString(string: "Example: cheese,tomato", attributes: [NSAttributedString.Key.foregroundColor : FlatWhite().withAlphaComponent(0.75)])
        
        
        filterView.backgroundColor = FlatNavyBlue()
        filterViewHeight.constant = 0
        filterView.alpha = 0
        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        searchButton.backgroundColor = FlatBlue().darken(byPercentage: 0.05)
        searchButton.layer.cornerRadius = 15
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.borderWidth = 1.5
        
        navigationItem.titleView = self.addFiltersButton
        
        activityIndicator.color = .black
    }
    
    
    func configureDropDown() {
        cuisineDropDown.anchorView = cuisineButton
        cuisineDropDown.dataSource = MyConstants.shared.cuisineType
        cuisineDropDown.bottomOffset = CGPoint(x: 0, y:(cuisineDropDown.anchorView?.plainView.bounds.height)!)
        cuisineDropDown.backgroundColor = .white
        cuisineDropDown.selectionBackgroundColor = FlatWhiteDark()
        cuisineDropDown.selectedTextColor = .blue
//        cuisineDropDown.showsLargeContentViewer = false
        cuisineDropDown.cancelAction = {
            self.cuisineButton.setImage(UIImage(named: "SF_arrow_down_to_line_alt"), for: .normal)
        }
        cuisineDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.cuisineButton.setImage(UIImage(named: "SF_arrow_down_to_line_alt"), for: .normal)
            if index == 0 {
                self.url?.queryItems?[1].value = ""
                self.cuisineButton.setTitle("Cuisines", for: .normal)
            } else {
                self.url?.queryItems?[1].value = item
                self.cuisineButton.setTitle(item, for: .normal)
            }
            print(self.url!)
        }
        
        dietDropDown.anchorView = dietButton
        dietDropDown.dataSource = MyConstants.shared.dietTypes
        dietDropDown.bottomOffset = CGPoint(x: 0, y:(dietDropDown.anchorView?.plainView.bounds.height)!)
        dietDropDown.backgroundColor = .white
        dietDropDown.selectionBackgroundColor = FlatWhiteDark()
        dietDropDown.selectedTextColor = .blue
        dietDropDown.cancelAction = {
            self.dietButton.setImage(UIImage(named: "SF_arrow_down_to_line_alt"), for: .normal)
        }
        dietDropDown.selectionAction = { [weak self] (index,item) in
            guard let self = self else { return }
            self.dietButton.setImage(UIImage(named: "SF_arrow_down_to_line_alt"), for: .normal)
            if index == 0 {
                self.url?.queryItems?[2].value = ""
                self.dietButton.setTitle("Diet", for: .normal)
            } else {
                self.url?.queryItems?[2].value = item
                self.dietButton.setTitle(item, for: .normal)
            }
            print(self.url!)
        }
        
        mealTypesDropDown.anchorView = mealTypeButton
        mealTypesDropDown.dataSource = MyConstants.shared.mealTypes
        mealTypesDropDown.bottomOffset = CGPoint(x: 0, y:(mealTypesDropDown.anchorView?.plainView.bounds.height)!)
        mealTypesDropDown.backgroundColor = .white
        mealTypesDropDown.selectionBackgroundColor = FlatWhiteDark()
        mealTypesDropDown.selectedTextColor = .blue
        mealTypesDropDown.cancelAction = {
            self.mealTypeButton.setImage(UIImage(named: "SF_arrow_down_to_line_alt"), for: .normal)
        }
        mealTypesDropDown.selectionAction = { [weak self] (index,item) in
            guard let self = self else { return }
            self.mealTypeButton.setImage(UIImage(named: "SF_arrow_down_to_line_alt"), for: .normal)
            if index == 0 {
                self.url?.queryItems?[3].value = ""
                self.mealTypeButton.setTitle("Meal Type", for: .normal)
            } else {
                self.url?.queryItems?[3].value = item
                self.mealTypeButton.setTitle(item, for: .normal)
            }
            print(self.url!)
        }
        
        timeDropDown.anchorView = readyTimeButton
        timeDropDown.dataSource = MyConstants.shared.readyTime
        timeDropDown.bottomOffset = CGPoint(x: 0, y:(timeDropDown.anchorView?.plainView.bounds.height)!)
        timeDropDown.backgroundColor = .white
        timeDropDown.selectionBackgroundColor = FlatWhiteDark()
        timeDropDown.selectedTextColor = .blue
        timeDropDown.cancelAction = {
            self.readyTimeButton.setImage(UIImage(named: "SF_arrow_down_to_line_alt"), for: .normal)
        }
        timeDropDown.selectionAction = { [weak self] (index,item) in
            guard let self = self else { return }
            self.readyTimeButton.setImage(UIImage(named: "SF_arrow_down_to_line_alt"), for: .normal)
            if index == 0 {
                self.url?.queryItems?[4].value = "1000"
                self.readyTimeButton.setTitle("Ready Time", for: .normal)
            } else {
                let time = item.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                self.url?.queryItems?[4].value = time
                self.readyTimeButton.setTitle(item, for: .normal)
            }
            print(self.url!)
        }
    }
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func showFilters() {
        if !isCollapsed {
            UIView.animate(withDuration: 0.5) {
                self.filterViewHeight.constant = self.view.frame.height - 200
                self.filterView.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.filterView.alpha = 0
                self.filterViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        isCollapsed.toggle()
    }
    

    @IBAction func filterTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            cuisineDropDown.show()
            cuisineButton.setImage(UIImage(named: "SF_arrow_up_right_circle"), for: .normal)
        } else if sender.tag == 1 {
            dietDropDown.show()
            dietButton.setImage(UIImage(named: "SF_arrow_up_right_circle"), for: .normal)
        } else if sender.tag == 2 {
            mealTypesDropDown.show()
            mealTypeButton.setImage(UIImage(named: "SF_arrow_up_right_circle"), for: .normal)
        } else if sender.tag == 3 {
            timeDropDown.show()
            readyTimeButton.setImage(UIImage(named: "SF_arrow_up_right_circle"), for: .normal)
        }
        
        
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        isCollapsed.toggle()
        UIView.animate(withDuration: 0.5) {
            self.filterView.alpha = 0
            self.filterViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }
        
        viewModel.getData(urlComponents: self.url!, pagination: false)
        
    }
    
    
}

//MARK: - TableView & TextField Configurations
extension SearchRecipeFilterViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipeElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RandomRecipeTableViewCell
        let element = viewModel.recipeElements[indexPath.row]
        let imageURL = URL(string: "https://spoonacular.com/recipeImages/\(element.id)-556x370.jpg")
        cell.recipeImage.sd_setImage(with: imageURL, completed: nil)
        cell.recipeName.text = element.title
        cell.recipeName.adjustsFontSizeToFitWidth = true
        cell.recipeName.minimumScaleFactor = 0.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let elementID = viewModel.recipeElements[indexPath.row].id
        let storyboard = UIStoryboard(name: "RecipeContent", bundle: nil)
        let tabbarVC = storyboard.instantiateInitialViewController() as! UITabBarController
        let overviewVC = tabbarVC.viewControllers?.first as? OverviewViewController
        overviewVC?.id = elementID
        navigationController?.pushViewController(tabbarVC, animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        guard let text = textField.text else { return false }
        self.url?.queryItems?[5].value = text
        print(self.url!)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChars = CharacterSet(charactersIn: "qwertyuiopasdfghjklzxcvbnm,")
        let charSet = CharacterSet(charactersIn: string)
        return allowedChars.isSuperset(of: charSet)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.url?.queryItems?[5].value = text
        print(self.url!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let postition = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        guard viewModel.totalResult != viewModel.recipeElements.count else {
            self.tableView.tableFooterView = UIView()
            return
        }
        self.tableView.tableFooterView = viewModel.isPaginating ? self.footerPaginationView : UIView()
        if postition > contentHeight - scrollViewHeight + 70 {
            guard !viewModel.isPaginating else { return }
            viewModel.getData(urlComponents: self.url!, pagination: true)
        }
        
    }
    
}


