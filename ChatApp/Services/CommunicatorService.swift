//
//  CommunicatorService.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol ICommunicatorService {
    
    var communicator: CommunicationManager { get }
}

class CommunicatorService: ICommunicatorService {
    
    var coreAssembly: ICoreAssembly!
    
    var communicator: CommunicationManager {
        get {
            return self.coreAssembly.communicator
        }
    }
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
}
