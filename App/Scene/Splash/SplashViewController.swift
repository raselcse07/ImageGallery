//
//  SplashViewController.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

class SplashViewController: BaseViewController, ViewModelable, Coordinatable, RootViewConfigurator {
    
    // MARK: - ViewModel, Coordinator & RootView Type
    typealias ViewModelType = SplashViewModel
    typealias CoordinatorType = SplashCoordinator
    typealias RootViewType = SplashView
    
    // MARK: - Properties
    var viewModel: SplashViewModel!
    var coordinator: SplashCoordinator?
    
    // MARK: - Life Cycle
    override func loadView() {
        view = RootViewType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didFinish()
    }
    
    override func bindViewModel() {
        viewModel
            .rx
            .finish
            .bind { state in
                print(state)
            }
            .disposed(by: disposeBag)
    }
}
