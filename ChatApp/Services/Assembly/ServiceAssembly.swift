//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
    var storageManager: IStorageManager { get set }
    
    var photoService: IPhotoService { get set }
}

class ServiceAssembly: IServiceAssembly {
    
    var storageManager: IStorageManager = StorageManager()
    
    var photoService: IPhotoService = PhotoService()
}
