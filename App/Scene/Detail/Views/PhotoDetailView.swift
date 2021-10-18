//
//  PhotoDetailView.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/18.
//

import Foundation
import UIKit

class PhotoDetailView: BaseView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupSubviews() {
        addSubview(imageView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setup(with model: Photo) {
        let url = URL(string: model.src.large2x)
        imageView.load(from: url)
    }
}
