//
//  PhotoListCoordinator.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation
import UIKit

class PhotoListCoordinator: BaseCoordinator {
    
    required init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        navigationController.show()
    }
    
    override func start() {
        let viewModel: PhotoListViewModel = .init()
        var viewController: PhotoListViewController = .init(viewModel: viewModel)
        viewController.register(to: self)
        set([viewController], animated: false)
    }
}
