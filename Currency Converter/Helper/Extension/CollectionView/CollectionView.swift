//
//  CollectionView.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 30.06.2022.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(with commonId: String) {
        register(UINib(nibName: commonId, bundle: nil), forCellWithReuseIdentifier: commonId)
    }
    
    func registerCells(_ cells: [UICollectionViewCell.Type]) {
        for cell in cells {
            register(nibFromClass(cell), forCellWithReuseIdentifier: cell.nameOfClass)
        }
    }
    
    fileprivate func nibFromClass(_ type: UIView.Type) -> UINib {
        return UINib(nibName: type.nameOfClass, bundle: nil)
    }
}

