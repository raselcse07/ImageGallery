//
//  PhotoDetailCoordinator.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/18.
//

import Foundation
import UIKit

class PhotoDetailCoordinator: BaseCoordinator {
    
    func start(with photo: Photo) {
        let viewModel: PhotoDetailViewModel = .init(photo: photo)
        var viewController: PhotoDetailController = .init(viewModel: viewModel)
        viewController.register(to: self)
        push(viewController)
    }
}
