//
//  PhotoListView.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation
import UIKit

class PhotoListView: BaseView {
    
    var collectionView: UICollectionView = {
        let flowlayout = PhotoListView.createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        flowlayout.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
        return collectionView
    }()
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.frame = bounds
    }
    
    ///- Tag: Layout
    static private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 4
        layout.sectionInset = .init(top: 0, left: padding, bottom: 0, right: padding)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }
}
