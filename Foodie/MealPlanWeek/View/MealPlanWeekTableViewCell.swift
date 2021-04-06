//
//  MealPlanWeekTableViewCell.swift
//  Foodie
//
//  Created by Marwan Osama on 2/11/21.
//

protocol CollectionViewItemSelectionDelegate {
    func didSelect(id: Int)
}

import UIKit

class MealPlanWeekTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    let cellIdentifier = "MealPlanWeekCollectionViewCell"
    var delegate: CollectionViewItemSelectionDelegate?
    var meals: [MealWeek] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.frame.width, height: 230)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: "MealPlanWeekCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(day: Day) {
        self.caloriesLabel.text = "Calories: \(day.nutrients.calories)"
        self.carbLabel.text = "Carbohydrates: \(day.nutrients.carbohydrates)"
        self.proteinLabel.text = "Proteins: \(day.nutrients.protein)"
        self.fatLabel.text = "Fats: \(day.nutrients.fat)"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MealPlanWeekCollectionViewCell
        let meal = meals[indexPath.row]
        cell.configureCell(meal: meal)        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let mealID = meals[indexPath.row].id
        self.delegate?.didSelect(id: mealID)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    
}


