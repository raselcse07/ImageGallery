//
//  UINavigationController+Ext.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

extension UINavigationController {
    
    // Hide Navigation Bar
    func hide(animated: Bool = true) {
        setNavigationBarHidden(true, animated: animated)
    }
    
    // Show Navigation Bar
    func show(animated: Bool = true) {
        setNavigationBarHidden(false, animated: animated)
    }
}
