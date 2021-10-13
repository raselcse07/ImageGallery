//
//  BaseView.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

class BaseView: UIView, UIConfigurator {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDcoder: NSCoder) {
        super.init(coder: aDcoder)
        configure()
    }
    
    func setupSubviews() {
        // just overrride it
    }
    
    func setupConstraints() {
        // just override it
    }
}
