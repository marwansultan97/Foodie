//
//  Extensions.swift
//  Foodie
//
//  Created by Marwan Osama on 2/12/21.
//

import UIKit
import ChameleonFramework

extension UICollectionView {
    
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        print(decelerationRate.rawValue)
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

extension UITableView {
    
    func setupRefresh() {
        let refreshController = UIRefreshControl()
        refreshController.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
        refreshController.attributedTitle = NSAttributedString(string: "Refresh", attributes: [NSAttributedString.Key.foregroundColor : FlatSkyBlue() , NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .heavy)])
        refreshControl = refreshController
        
    }
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
