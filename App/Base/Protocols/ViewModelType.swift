//
//  ViewModelType.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation


protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var input: Input! { get }
    var output: Output! { get }
    
}
