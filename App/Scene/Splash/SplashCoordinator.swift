//
//  SplashCoordinator.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

final class SplashCoordinator: BaseCoordinator {
    
    required init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        self.navigationController.hide()
    }
    
    override func start() {
        let viewModel: SplashViewModel = .init()
        var viewController: SplashViewController = .init(viewModel: viewModel)
        viewController.register(to: self)
        push(viewController)
    }
}
