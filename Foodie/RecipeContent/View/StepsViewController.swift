//
//  StepsViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 1/28/21.
//

import UIKit

class StepsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var tableView: UITableView!
    
    let equipmentCellIdentifier = "IngredientCell"
    let stepsCellIdentifier = "StepsCell"
    
    
    var steps = [Step]()
    var equipments = [Ent]()
    
    var recipe: Recipe? {
        didSet {
            guard let steps = recipe?.analyzedInstructions.first?.steps else { return }
            self.steps = steps
            configureEquipmentsCell()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureEquipmentsCell() {
        steps.forEach{ (step) in
            step.equipment.forEach { (equipment) in
                if !equipments.contains(equipment) {
                    equipments.append(equipment)
                }
            }
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 70
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: equipmentCellIdentifier)
    }
    
    
    //MARK: - TableView Configurations
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? equipments.count : steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: equipmentCellIdentifier, for: indexPath) as! IngredientTableViewCell
            let equipment = self.equipments[indexPath.row]
            cell.configureEquipmentsCell(equipment: equipment)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: stepsCellIdentifier, for: indexPath)
            let step = self.steps[indexPath.row]
            cell.textLabel?.text = "\(step.number)) " + step.step
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = .black
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.flatBlue()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        label.text = section == 0 ? "Equipments you need" : "How to make"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        headerView.addSubview(label)
        label.center = headerView.center
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : UITableView.automaticDimension
    }
    
    
    
    

}

extension RangeReplaceableCollection where Element: Hashable {
    var orderedSet: Self {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}




