//
//  SplashView.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

class SplashView: BaseView {
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Const.LOGO)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupSubviews() {
        addSubview(logo)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
