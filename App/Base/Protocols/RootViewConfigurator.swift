//
//  RootViewConfigurator.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

/// exchange the regular view property of `UIViewController`.
/// provide a custom view to`UIViewController` at the `loadView()` method.
protocol RootViewConfigurator {
    associatedtype RootViewType: UIView
}

extension RootViewConfigurator where Self: UIViewController {
    var rootView: RootViewType {
        guard let customView = view as? RootViewType else {
            fatalError("Expected view to be of type \(RootViewType.self) but got \(type(of: view)) instead")
        }
        return customView
    }
}




