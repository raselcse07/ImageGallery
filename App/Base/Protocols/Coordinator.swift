//
//  Coordinator.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    /// Each coordinator has one navigation controller assigned to it
    var navigationController: UINavigationController { get set }
    /// Initializer
    init(navigationController: UINavigationController)
    /// A place to put logic to start the flow
    func start()
}
