//
//  CommunicationManager.swift
//  ChatApp
//
//  Created by Иван Лебедев on 18/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol CommunicatorDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func stateChanged(displayName: String, state: MCSessionState)
}

protocol IBaseCommunicatorManager {
    var communicator: MultipeerCommunicator { get }
}

class CommunicationManager: IBaseCommunicatorManager, CommunicatorDelegate {
    
    func didFoundUser(userID: String, userName username: String?) {
        delegate?.didFoundUser(userID: userID, userName: username)
    }
    
    func didLostUser(userID: String) {
        delegate?.didLostUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        delegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func stateChanged(displayName: String, state: MCSessionState) {
        delegate?.stateChanged(displayName: displayName, state: state)
    }
    
    var communicator: MultipeerCommunicator
    weak var delegate: CommunicatorDelegate?
    
    init(userName: String) {
        self.communicator = MultipeerCommunicator(userName: userName)
        self.communicator.delegate = self
    }
    
}
