//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    
    var communicator: CommunicationManager { get set }
    
    var storageManager: StorageManager { get set }
    
    var requestSender: IRequestSender { get set }
    
}

class CoreAssembly: ICoreAssembly {
    
    public var communicator: (CommunicationManager)
    public var storageManager: (StorageManager)
    public var requestSender: (IRequestSender)
    
    init() {
        self.storageManager = StorageManager()
        let profile = self.storageManager.getUserProfile()
        self.communicator = CommunicationManager(userName: profile.name ?? "No name")
        self.requestSender = RequestSender()
    }
}
