//
//  MainAssembly.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol IMainAssembly {
    
    var presentationAssembly: IPresentationAssembly { get set }
    
    var serviceAssembly: IServiceAssembly { get set }
    
    var coreAssembly: ICoreAssembly { get set }
    
}

class MainAssembly: IMainAssembly {
    
    lazy var coreAssembly: ICoreAssembly = CoreAssembly()
    
    lazy var serviceAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: self.coreAssembly)
    
    lazy var presentationAssembly: IPresentationAssembly =
        PresentationAssembly(serviceAssembly: self.serviceAssembly)
}
