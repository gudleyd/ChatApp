//
//  NetworkService.swift
//  ChatApp
//
//  Created by Иван Лебедев on 16/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

protocol INetworkService {
    func takePixabayImages(completionHandler: @escaping (Result<ImagesParser.Model>) -> Void)
    
    func loadImages(batch: Int, batchHandler: @escaping ([UIImage], [PBImage]?) -> Void)
}

class NetworkService: INetworkService {
    
    let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    func takePixabayImages(completionHandler: @escaping (Result<ImagesParser.Model>) -> Void) {
        self.coreAssembly.requestSender.send(config: RequestsFactory.PixabayConfig.AvatarsListRequest()) { (result) in
            print(result)
            completionHandler(result)
        }
    }
    
    func loadImages(batch: Int, batchHandler: @escaping ([UIImage], [PBImage]?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let mainGroup = DispatchGroup()
            mainGroup.enter()
            var list: [PBImage]!
            self.takePixabayImages(completionHandler: { (result) in
                switch result {
                case .success(let imageList):
                    list = imageList
                case .error(let err):
                    Debugger.shared.dbprint("loadImages Error \(err)")
                    batchHandler([], nil)
                    return
                }
                mainGroup.leave()
            })
            mainGroup.wait()
            var images: [UIImage] = []
            for imageToLoad in list {
                if let url = URL(string: imageToLoad.previewURL),
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    images.append(image)
                    if images.count == batch {
                        batchHandler(images, list)
                        images = []
                    }
                }
            }
        }
    }
}
