//
//  ViewModelable.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

protocol ViewModelable {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    init(viewModel: ViewModelType)
}

extension ViewModelable where Self: UIViewController {
    init(viewModel: ViewModelType) {
        self.init()
        self.viewModel = viewModel
    }
}
