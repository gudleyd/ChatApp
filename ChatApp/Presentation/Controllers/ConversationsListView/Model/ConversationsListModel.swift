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
    private var storageService: IStorageService!
    
    init(storageService: IStorageService) {
        self.storageService = storageService
    }
    
    func updateConversationHasUnreadMessages(userID: String, hasUnreadMessages: Bool) {
        self.storageService.updateConversationHasUnreadMessages(userID: userID,
                                                                hasUnreadMessages: hasUnreadMessages)
    }
}
