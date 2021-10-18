//
//  PhotoDetailController.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/17.
//

import Foundation
import UIKit


class PhotoDetailController: BaseViewController, ViewModelable, Coordinatable, RootViewConfigurator {
    
    // MARK: - ViewModel, Coordinator & RootView Type
    typealias ViewModelType = PhotoDetailViewModel
    typealias CoordinatorType = PhotoDetailCoordinator
    typealias RootViewType = PhotoDetailView
    
    // MARK: - Properties
    var viewModel: PhotoDetailViewModel!
    var coordinator: PhotoDetailCoordinator?

    // MARK: - Life Cycle
    override func loadView() {
        view = RootViewType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.setup(with: viewModel.output.photo)
    }
}
