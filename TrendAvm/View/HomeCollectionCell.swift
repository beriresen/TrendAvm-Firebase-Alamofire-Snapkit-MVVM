//
//  HomeCollectionCell.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 2.03.2023.
//

import UIKit

class HomeCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        // we have to implement this initializer, but will only ever use this class programmatically
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupCell(colour: UIColor) {
            self.backgroundColor = colour
        }
}
