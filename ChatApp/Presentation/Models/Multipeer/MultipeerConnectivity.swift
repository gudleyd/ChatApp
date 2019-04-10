//
//  MultipeerConnectivity.swift
//  ChatApp
//
//  Created by Иван Лебедев on 18/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Communicator {
    func sendMessage(text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol CommunicatorDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)

    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func stateChanged(displayName: String, state: MCSessionState)
}
