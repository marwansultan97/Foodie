//
//  MenuListViewController.swift
//  Foodie
//
//  Created by Marwan Osama on 2/9/21.
//

import UIKit

class MenuListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier = "MenuListCollectionViewCell"
    
    private let viewModel = MenuListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menus"
        configureCollectionView()
        initVM()
    }
    
    func initVM() {
        viewModel.didRecieveMenus = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.setMenuList()
    }
    
    //MARK: - CollectionView Configurations
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width/2.6
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 35
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: width/7.5, bottom: 0, right: width/7.5)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MenuListCollectionViewCell
        let menu = viewModel.menus[indexPath.row]
        cell.iconImageView.image = UIImage(named: menu.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemUrlQuery = viewModel.menus[indexPath.row].urlQuery
        let listName = viewModel.menus[indexPath.row].name
        let vc = UIStoryboard(name: "MenuListItems", bundle: nil).instantiateInitialViewController() as? MenuListItemsViewController
        vc?.query = itemUrlQuery
        vc?.navTitle = listName
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }

}
