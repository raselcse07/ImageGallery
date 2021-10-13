//
//  Coordinatable.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import UIKit

protocol Coordinatable {
    associatedtype CoordinatorType: Coordinator
    var coordinator: CoordinatorType? { get set }
    mutating func register(to coordinator: CoordinatorType)
}

extension Coordinatable where Self: UIViewController {
    mutating func register(to coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }
}
