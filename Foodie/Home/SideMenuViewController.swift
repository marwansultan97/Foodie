//
//  SideMenuViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/8/21.
//

import UIKit
import ChameleonFramework

struct SideMenuOptions {
    let title: String
    let image: UIImage?
    let handler: (()->())?
    var opened: Bool
    let childern: [SideMenuOptions]?

}

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var sideMenuOptions = [SideMenuOptions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        configureSideMenuOptions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        configureSideMenuOptions()
        tableView.reloadData()
    }
    
    func configureSideMenuOptions() {
        sideMenuOptions = [
            SideMenuOptions(title: "Search Recipes",
                            image: UIImage(systemName: "folder"),
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
            SideMenuOptions(title: "Menu Items",
                            image: UIImage(named: "icons8-meal"),
                            handler: {
                                print("menu")
                            },
                            opened: false,
                            childern: nil)
        
        ]
    }

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
            cell.tintColor = .label
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
            tableView.reloadSections(index, with: .none)
        } else if indexPath.row == 0 && sideMenuOptions[indexPath.section].childern == nil{
            sideMenuOptions[indexPath.section].handler!()
        } else {
            sideMenuOptions[indexPath.section].childern![indexPath.row - 1].handler!()
        }
    }
    
    
}
