//
//  BaseCollectionViewCell.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell, UIConfigurator {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDcoder: NSCoder) {
        super.init(coder: aDcoder)
        configure()
    }
    
    func setupSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
}
