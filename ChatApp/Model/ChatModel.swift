//
//  ChatModel.swift
//  ChatApp
//
//  Created by Иван Лебедев on 22/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

class ChatModel : ChatCellConfigurationProtocol {
    var name: String?
    var lastMessage: String?
    var lastMessageDate: Date?
    var online: Bool?
    var hasUnreadMessages: Bool
    var isLastMessageByMe: Bool
    
    init(_ name: String?, _ lastMessage: String?, _ lastMessageDate: Date?, _ online: Bool?, _ hasUnreadMessages: Bool, _ isLastMessageByMe: Bool) {
        self.name = name
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.isLastMessageByMe = isLastMessageByMe
    }
}
