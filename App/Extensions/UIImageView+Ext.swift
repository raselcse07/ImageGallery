//
//  UIImage+Ext.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/17.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func load(from url: URL?) {
        // Processor
        let proccessor = RoundCornerImageProcessor(cornerRadius: 5)
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: UIImage(named: Const.LOGO),
            options: [
                .processor(proccessor),
                .transition(.fade(1.5)),
            ], completionHandler: nil)
    }
}
