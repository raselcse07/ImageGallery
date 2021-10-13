//
//  UIConfigurator.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

protocol UIConfigurator {
    /// - Configure view here.
    func configure()
    /// - Add subviews
    func setupSubviews()
    /// - Add Constraints
    func setupConstraints()
}

extension UIConfigurator {
    func configure() {
        setupSubviews()
        setupConstraints()
    }
}
