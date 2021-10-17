//
//  PhotoListCell.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation
import UIKit

class PhotoListCell: BaseCollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Copperplate-Light", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    static let indentifier = String(describing: "\(PhotoListCell.self)")
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        let padding: CGFloat = 4
        let noOfItems = traitCollection.horizontalSizeClass == .compact ? 2 : 4
        let itemWidth = floor((UIScreen.main.bounds.width - (padding * 2)) / CGFloat(noOfItems))
        
        return super.systemLayoutSizeFitting(.init(width: itemWidth, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        textLabel.text = nil 
    }
    
    override func setupSubviews() {
        contentView.addSubview(stackView)
        [imageView, textLabel].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func setupConstraints() {
        
        let imageHeightAnchor = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        imageHeightAnchor.priority = .init(999)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            imageHeightAnchor
        ])
    }
    
    func setup(model: Photo) {
        let imageURL = URL(string: model.src.medium)
        imageView.load(from: imageURL)
        textLabel.text = model.photographer.uppercased()
    }
}
