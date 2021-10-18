//
//  PhotoDetailViewModel.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/18.
//

import Foundation

class PhotoDetailViewModel: ViewModelType {
    
    // Input
    struct Input {}
    
    // Output
    struct Output {
        let photo: Photo
    }
    
    var input: Input!
    var output: Output!
    private let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
        self.bind()
    }
    
    func bind() {
        input = Input()
        output = Output(photo: photo)
    }
}
