//
//  Reactive+UIScrollView.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/17.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    func toBottom() -> ControlEvent<Bool> {
        let offset: CGFloat = 0.0
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        return ControlEvent(events: source)
    }
}
