//
//  ConversationsListModel.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol IConversationsListModel {
    func updateConversationHasUnreadMessages(userID: String,
                                             hasUnreadMessages: Bool)
}

class ConversationsListModel: IConversationsListModel {
    private var storageManager: IStorageManager!
    
    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    func updateConversationHasUnreadMessages(userID: String, hasUnreadMessages: Bool) {
        self.storageManager.updateConversationHasUnreadMessages(userID: userID,
                                                                hasUnreadMessages: hasUnreadMessages)
    }
}
