//
//  SplashViewController.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit
import RxSwift

class SplashViewController: BaseViewController, Coordinatable, RootViewConfigurator {
    
    // MARK: - Coordinator & RootView Type
    typealias CoordinatorType = SplashCoordinator
    typealias RootViewType = SplashView
    
    // MARK: - Properties
    var coordinator: SplashCoordinator?
    
    // MARK: - Life Cycle
    override func loadView() {
        view = RootViewType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Finished Initialization
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.coordinator?.startPhotoList()
        }
    }
}
