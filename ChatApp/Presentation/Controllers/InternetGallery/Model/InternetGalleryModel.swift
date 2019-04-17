//
//  InternetGalleryModel.swift
//  ChatApp
//
//  Created by Иван Лебедев on 16/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

protocol IInternetGalleryModel {
    func loadImages(batch: Int, batchHandler: @escaping ([UIImage], [PBImage]?) -> Void)
    
    func takeImagesCount() -> Int
    
    func PBPictureHasChosen(pbimage: PBImage)
    
    var delegate: IPBPictureHasChosenDelegate? { get set }
}

class InternetGalleryModel: IInternetGalleryModel {
    
    weak var delegate: IPBPictureHasChosenDelegate?
    var networkService: INetworkService!
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func takeImagesCount() -> Int {
        return RequestsFactory.PixabayConfig.imageCount
    }
    
    func loadImages(batch: Int, batchHandler: @escaping ([UIImage], [PBImage]?) -> Void) {
        self.networkService.loadImages(batch: batch, batchHandler: batchHandler)
    }
    
    func PBPictureHasChosen(pbimage: PBImage) {
        self.delegate?.PBPictureHasChosen(pbimage: pbimage)
    }
}
