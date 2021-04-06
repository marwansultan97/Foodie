//
//  MenuListItemInformationViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/10/21.
//

protocol BackDelegate {
    func backButtonTapped()
}

import UIKit

class MenuListItemInformationViewController: UIViewController {

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "MenuListItemInformation"
    var delegate: BackDelegate?
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    var menuItemID: Int? {
        didSet {
            guard menuItemID != nil else { return }
            viewModel = MenuListItemInformationViewModel(id: menuItemID!)
        }
    }
    
    var viewModel: MenuListItemInformationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        initVM()
    }
    
    func initVM() {
        viewModel?.didRecieveMenuItemInformation = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.itemName.text = "Nutritions of\n\(self.viewModel!.itemInformation!.title)"
        }
        
        viewModel?.didRecieveErrorMessage = { [weak self] in
            guard let self = self else { return }
            self.itemName.text = self.viewModel!.errorMessage
        }
        
        viewModel?.getInformation()
    }
    
    //MARK: - UI Configurations
    func configureUI() {
        contentViewHeight.constant = UIScreen.main.bounds.height/4 * 3 - 50
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissal)))
        itemName.adjustsFontSizeToFitWidth = true
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    
    //MARK: - Pan Gesture Dismissal Configurations
    @objc func handleDismissal(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            break
        case .possible:
            break
        case .changed:
            viewTranslation = sender.translation(in: view)
            if viewTranslation.y > 0 {
                UIView.animate(withDuration: 0,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 1,
                               options: .curveLinear,
                               animations: {
                                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                               }, completion: nil)
            }
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1,
                               options: .curveLinear,
                               animations: {
                                self.view.transform = .identity
                               })
                
            } else {
                dismiss(animated: true, completion: nil)
                delegate?.backButtonTapped()
            }
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
}

//MARK: - TableView Configurations
extension MenuListItemInformationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.itemInformation?.nutrition.nutrients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MenuListItemInformationTableViewCell
        let nutrient = viewModel?.itemInformation?.nutrition.nutrients[indexPath.row]
        cell.nutritionsLabel.text = "\(nutrient!.name): \(nutrient!.amount) \(nutrient!.unit)"
        cell.nutritionsLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    
}
