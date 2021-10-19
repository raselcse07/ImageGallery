//
//  UICollectionView+Ext.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/19.
//

import UIKit

extension UICollectionView {
    
    // cell registration
    func register<Cell: UICollectionViewCell>(_ cell: Cell.Type) {
        let identifier = String(describing: cell)
        if Bundle.main.path(forResource: identifier, ofType: "nib") != nil {
            register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        } else {
            register(cell, forCellWithReuseIdentifier: identifier)
        }
    }
    
    // supplementary view registration
    func register<View: UICollectionReusableView>(view: View.Type, forSupplementaryViewOfKind: String) {
        let identifier = String(describing: view)
        if Bundle.main.path(forResource: identifier, ofType: "nib") != nil {
            register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: identifier)
        } else {
            register(view, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: identifier)
        }
    }
    
    // dequeueReusableCell
    func dequeueReusableCell<Cell: UICollectionViewCell>(with cellType: Cell.Type, indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as! Cell
    }
    
    // footer view with activity indicator
    func dequeueReusableSupplementaryView<View: UICollectionReusableView>(with viewType: View.Type, kind: String, indexPath: IndexPath) -> View {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: viewType), for: indexPath) as! View
    }
    
    // insert items
    func insertItems(start: Int, end: Int, indexPath: [IndexPath], completion: @escaping () -> Void) {
        if start < end {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                self.insertItems(at: indexPath)
                completion()
            }
        } else {
            reloadData()
            completion()
        }
    }
}
