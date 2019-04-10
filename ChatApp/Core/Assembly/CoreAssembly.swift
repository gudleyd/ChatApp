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
    
}

class CoreAssembly: ICoreAssembly {
    
    public var communicator: (CommunicationManager)
    
    init() {
        let profile = StorageManager().getUserProfile()
        self.communicator = CommunicationManager(userName: profile.name ?? "No name")
    }
}
