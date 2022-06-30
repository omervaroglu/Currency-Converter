//
//  BalanceCollectionViewCell.swift
//  Currency Converter
//
//  Created by Ömer Faruk Varoğlu on 30.06.2022.
//

import UIKit

class BalanceCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var balanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setCell(currency: String, amount: String) {
        balanceLabel.text = amount + " " + currency 
    }
}
