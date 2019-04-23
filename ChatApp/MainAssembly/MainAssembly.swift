//
//  MainAssembly.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

protocol IMainAssembly {
    
    var presentationAssembly: IPresentationAssembly { get set }
    
    var serviceAssembly: IServiceAssembly { get set }
    
    var coreAssembly: ICoreAssembly { get set }
    
}

class MainAssembly: IMainAssembly {
    
    var coreAssembly: (ICoreAssembly)
    var serviceAssembly: (IServiceAssembly)
    var presentationAssembly: (IPresentationAssembly)
    
    init(mainWindow: UIWindow) {
        self.coreAssembly = CoreAssembly()
        self.serviceAssembly = ServiceAssembly(coreAssembly: self.coreAssembly,
                                               mainWindow: mainWindow)
        self.presentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    }
}
