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
        var viewController: SplashViewController = .init()
        viewController.register(to: self)
        set([viewController])
    }
    
    func startPhotoList() {
        let photoListCoordinator: PhotoListCoordinator = .init(navigationController: navigationController)
        photoListCoordinator.start()
    }
}
