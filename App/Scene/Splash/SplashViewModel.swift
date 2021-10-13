//
//  SplashViewModel.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel: NSObject {
    
    // MARK: - Properties
    fileprivate let finishRelay: BehaviorRelay<Bool> = .init(value: false)
    var finish: Bool {
        get {
            return finishRelay.value
        }
        set {
            finishRelay.accept(newValue)
        }
    }
    
    func didFinish() {
        finish = true
    }
}

// MARK: - Reactive extension
extension Reactive where Base: SplashViewModel {
    
    var finish: BehaviorRelay<Bool> {
        return base.finishRelay
    }
}
