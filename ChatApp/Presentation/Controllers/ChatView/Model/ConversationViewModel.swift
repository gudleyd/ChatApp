//
//  ConversationViewModel.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol IConversationViewModel {
    func connectWithUser(userID: String) -> Bool
    
    func disconnectPeers()
    
    func updateConversationHasUnreadMessages(userID: String,
                                             hasUnreadMessages: Bool)
    
    func sendMessage(text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
}

class ConversationViewModel: IConversationViewModel {
    
    var communicator: ICommunicatorService!
    
    var storageManager: IStorageService!
    
    init(communicator: ICommunicatorService,
         storageManager: IStorageService) {
        self.communicator = communicator
        self.storageManager = storageManager
    }
    
    func connectWithUser(userID: String) -> Bool {
        if self.communicator.communicator.communicator.session.connectedPeers.filter({$0.displayName == userID}).count != 0 {
            return true
        } else {
            self.communicator.communicator.communicator.connectPeer(userID: userID)
            return false
        }
    }
    
    func disconnectPeers() {
        self.communicator.communicator.communicator.disconnectPeers()
    }
    
    func updateConversationHasUnreadMessages(userID: String, hasUnreadMessages: Bool) {
        self.storageManager.updateConversationHasUnreadMessages(userID: userID,
                                                                hasUnreadMessages: hasUnreadMessages)
    }
    
    func sendMessage(text: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        self.communicator.communicator.communicator.sendMessage(text: text, to: userID, completionHandler: completionHandler)
    }
}
