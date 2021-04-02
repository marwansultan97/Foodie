//
//  SideMenuViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/8/21.
//

import UIKit
import ChameleonFramework
import DynamicBlurView

struct SideMenuOptions {
    let title: String
    let image: UIImage?
    let handler: (()->())?
    var opened: Bool
    let childern: [SideMenuOptions]?

}

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var sideMenuOptions = [SideMenuOptions]()
    let backgroundImages: [String] = ["food1","food2","food3","food4","food5","food6","food7","food8","food9","food10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        configureSideMenuOptions()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        configureSideMenuOptions()
        tableView.reloadData()
    }
    
    //MARK: - Configure UI
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        sideMenuWidth.constant = UIScreen.main.bounds.width - 80
        let randomNumber = Int.random(in: 0...9)
        backgroundImage.image = UIImage(named: backgroundImages[randomNumber])
        let blurView = DynamicBlurView(frame: backgroundImage.frame)
        blurView.blurRadius = 10
        blurView.quality = .high
        backgroundImage.addSubview(blurView)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - SideMenu Elements
    func configureSideMenuOptions() {
        sideMenuOptions = [
            SideMenuOptions(title: "Search Recipes",
                            image: UIImage(named: "SF_folder_fill"),
                            handler: nil,
                            opened: false,
                            childern: [
                                SideMenuOptions(title: "Search by Name",
                                                image: nil,
                                                handler: {
                                                    self.sideMenuController?.hideMenu()
                                                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "SearchRecipeName"), object: nil)
                                                },
                                                opened: false,
                                                childern: nil),
                                SideMenuOptions(title: "Search with Filters",
                                                image: nil,
                                                handler: {
                                                    self.sideMenuController?.hideMenu()
                                                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "SearchRecipeFilters"), object: nil)
                                                },
                                                opened: false,
                                                childern: nil)
                            ]),
            SideMenuOptions(title: "Menus",
                            image: UIImage(named: "Ion_ios_restaurant"),
                            handler: nil,
                            opened: false,
                            childern: [SideMenuOptions(title: "Menu Lists",
                                                      image: nil, handler: {
                                                        self.sideMenuController?.hideMenu()
                                                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "MenuList"), object: nil)
                                                      },
                                                      opened: false,
                                                      childern: nil),
                                       SideMenuOptions(title: "Search Menu Items",
                                                       image: nil,
                                                       handler: {
                                                        self.sideMenuController?.hideMenu()
                                                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "MenuItemsSearch"), object: nil)
                                                       },
                                                       opened: false,
                                                       childern: nil)
                            ]),
            SideMenuOptions(title: "Meal Planner",
                            image: UIImage(named: "SF_circle_grid_3x3"),
                            handler: nil,
                            opened: false,
                            childern: [
                                SideMenuOptions(title: "Day Plan",
                                                image: nil,
                                                handler: {
                                                    print("day")
                                                    self.sideMenuController?.hideMenu()
                                                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "MealPlanDay"), object: nil)
                                                },
                                                opened: false,
                                                childern: nil),
                                SideMenuOptions(title: "Week Plan",
                                                image: nil,
                                                handler: {
                                                    print("week")
                                                    self.sideMenuController?.hideMenu()
                                                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "MealPlanWeek"), object: nil)
                                                },
                                                opened: false,
                                                childern: nil)
                            ])
            
        
        ]
    }
    
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sideMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sideMenuOptions[section].opened {
            return sideMenuOptions[section].childern!.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuTableViewCell
            cell.titleLabel.text = sideMenuOptions[indexPath.section].title
            cell.iconImageView.image = sideMenuOptions[indexPath.section].image
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuExpandCell", for: indexPath) as! SideMenuExpandTableViewCell
            cell.titleLabel.text = sideMenuOptions[indexPath.section].childern![indexPath.row - 1].title
            if indexPath.row == sideMenuOptions[indexPath.section].childern!.count - 1 {
                cell.separatorView.alpha = 0
            } else {
                cell.separatorView.alpha = 0.7
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 && sideMenuOptions[indexPath.section].childern != nil {
            sideMenuOptions[indexPath.section].opened.toggle()
            let index = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(index, with: .fade)
        } else if indexPath.row == 0 && sideMenuOptions[indexPath.section].childern == nil{
            sideMenuOptions[indexPath.section].handler!()
        } else {
            sideMenuOptions[indexPath.section].childern![indexPath.row - 1].handler!()
        }
    }
    
    
}

