//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
    
    var storageService: IStorageService { get set }
    
    var photoService: IPhotoService { get set }
    
    var communicatorService: ICommunicatorService { get set }
}

class ServiceAssembly: IServiceAssembly {
    
    var coreAssembly: ICoreAssembly!
    var storageService: (IStorageService)
    var communicatorService: (ICommunicatorService)
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
        self.storageService = StorageService(coreAssembly: self.coreAssembly)
        self.communicatorService = CommunicatorService(coreAssembly: self.coreAssembly)
    }
    
    var photoService: IPhotoService = PhotoService()
}
