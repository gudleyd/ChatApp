//
//  service.swift
//  ChatApp
//
//  Created by Иван Лебедев on 07/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

class Debugger {
    static let shared = Debugger()
    let DEBUG: Bool = true

    func dbprint(_ items: Any) {
        if DEBUG {
            print(items)
        }
    }
}

class StateLogger {

    var currentState: String?
    var instanceName: String?

    init(initialState: String, instanceName: String) {
        self.currentState = initialState
        self.instanceName = instanceName
    }

    func logState(stateName: String = #function, methodName: String = #function) {
        Debugger.shared.dbprint("\(instanceName ?? "#NONAME") moved from \(currentState ?? "#NONAME") to \(stateName): \(methodName)")
        currentState = stateName
    }
}
