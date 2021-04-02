//
//  OverviewViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 1/28/21.
//

struct ChipsOptions {
    var title: String
    var image: UIImage?
}


import UIKit
import MaterialComponents.MaterialChips
import ChameleonFramework
import SDWebImage

class OverviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var section1: [ChipsOptions] = [ChipsOptions]()
    var section2: [String] = [String]()
    
    lazy var viewModel: RecipeContentViewModel = {
        return RecipeContentViewModel(id: id!)
    }()
    
    var id: Int? {
        didSet {
            guard id != nil else { return }
            self.viewModel = RecipeContentViewModel(id: id!)
        }
    }
    
    var recipe: Recipe? {
        didSet {
            guard recipe != nil else { return }
            configureSectionsCells()
            if let imageURL = URL(string: self.recipe?.image ?? "") {
                self.recipeImageView.sd_setImage(with: imageURL, completed: nil)
            }
            self.recipeName.text = self.recipe?.title
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVM()
        configureUI()
        configureCollectionView()

    }
    
    //MARK: - ViewModel Binding
    func initVM() {
        
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
        viewModel.didRecieveErrorMessage = { [weak self] in
            guard let self = self else { return }
            print(self.viewModel.errorMessage!)
        }
        viewModel.didRecieveRecipeContent = { [weak self] in
            guard let self = self else { return }
            self.recipe = self.viewModel.recipeContent
            guard let ingredientsVC = self.tabBarController?.viewControllers?[1] as? IngredientsViewController else { return }
            guard let stepsVC = self.tabBarController?.viewControllers?[2] as? StepsViewController else { return }
            guard let nutritionsVC = self.tabBarController?.viewControllers?[3] as? NutritionsViewController else { return }
            ingredientsVC.recipe = self.viewModel.recipeContent
            stepsVC.recipe = self.viewModel.recipeContent
            nutritionsVC.recipe = self.viewModel.recipeContent
            
            self.collectionView.reloadData()
        }
        
        viewModel.getRecipes()
        
        
    }

    //MARK: - Configure UI
    func configureUI() {
        title = "Overview"
        self.tabBarController?.tabBar.barTintColor = FlatNavyBlue()
        tabBarController?.tabBar.tintColor = .white
        recipeImageView.layer.cornerRadius = 20
        recipeName.adjustsFontSizeToFitWidth = true
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true
        let layout = MDCChipCollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = layout
        collectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
    }
    
    
    //MARK: - CollectionView Chip Elements
    func configureSectionsCells() {
        // Section 1 Cells
        if let servings = recipe?.servings {
            section1.append(ChipsOptions(title: "Serves \(servings)", image: UIImage(named: "SF_person_crop_square_fill")))
        }
        
        if let servingPrice = recipe?.pricePerServing {
            let dollars = servingPrice/100
            let priceInDollars = String(format: "%.2f", dollars)
            section1.append(ChipsOptions(title: "\(priceInDollars) per serving", image: UIImage(named: "SF_dollarsign_circle")))
        }
        
        if let score = recipe?.spoonacularScore {
            section1.append(ChipsOptions(title: "\(score)% score", image: UIImage(named: "FA_Crown")))
        }
        
        if let mins = recipe?.readyInMinutes {
            section1.append(ChipsOptions(title: "Ready in \(mins) minutes", image: UIImage(named: "SF_stopwatch")))
        }
        
        // Section 2 Cells
        if let diets = recipe?.diets {
            diets.forEach { (diet) in
                section2.append(diet.rawValue)
            }
        }
        
        if let dishTypes = recipe?.dishTypes {
            section2.append(contentsOf: dishTypes)
        }
        
        if let occasions = recipe?.occasions {
            section2.append(contentsOf: occasions)
        }
        
    }
    
    
    //MARK: - CollectionView Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? section1.count : section2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! MDCChipCollectionViewCell
        
        if indexPath.section == 0 {
            let sectionModel1 = section1[indexPath.row]
            cell.chipView.setBackgroundColor(FlatBlue(), for: .normal)
            cell.chipView.setTitleColor(.white, for: .normal)
            cell.chipView.titleLabel.text = sectionModel1.title
            cell.chipView.imageView.image = sectionModel1.image
        } else {
            let sectionModel2 = section2[indexPath.row]
            cell.chipView.setBackgroundColor(FlatMintDark(), for: .normal)
            cell.chipView.setTitleColor(.white, for: .normal)
            cell.chipView.titleLabel.text = sectionModel2
        }
        
        cell.chipView.tintColor = .white
        cell.chipView.contentPadding = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        cell.isUserInteractionEnabled = false
        return cell
    }
    


}
