//
//  BaseCoordinator.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

class BaseCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    
    // MARK: - Initializer
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func set(_ viewController: [UIViewController], animated: Bool = true) {
        navigationController.setViewControllers(viewController, animated: animated)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
