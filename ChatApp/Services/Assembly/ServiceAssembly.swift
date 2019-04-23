//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

protocol IServiceAssembly {
    
    var storageService: IStorageService { get }
    
    var photoService: IPhotoService { get }
    
    var communicatorService: ICommunicatorService { get }
    
    var networkService: INetworkService { get }
    
    var logosService: ILogosService { get }
}

class ServiceAssembly: IServiceAssembly {
    
    var coreAssembly: ICoreAssembly!
    var storageService: (IStorageService)
    var communicatorService: (ICommunicatorService)
    var networkService: (INetworkService)
    var logosService: (ILogosService)
    
    init(coreAssembly: ICoreAssembly,
         mainWindow: UIWindow) {
        self.coreAssembly = coreAssembly
        self.storageService = StorageService(coreAssembly: self.coreAssembly)
        self.communicatorService = CommunicatorService(coreAssembly: self.coreAssembly)
        self.networkService = NetworkService(coreAssembly: self.coreAssembly)
        self.logosService = LogosService(window: mainWindow)
    }
    
    var photoService: IPhotoService = PhotoService()
}
