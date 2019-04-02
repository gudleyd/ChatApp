//
//  ChatModel.swift
//  ChatApp
//
//  Created by Иван Лебедев on 22/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

class Message {
    var text: String
    var fromMe: Bool
    var date: Date

    init(text: String, fromMe: Bool, date: Date) {
        self.text = text
        self.fromMe = fromMe
        self.date = date
    }
}

class ChatModel: ChatCellConfigurationProtocol {
    var name: String?
    var userID: String
    var lastMessage: String?
    var lastMessageDate: Date?
    var online: Bool?
    var hasUnreadMessages: Bool
    var isLastMessageByMe: Bool
    var messages: [CDMessage] = []

    init(_ name: String?, userID: String, _ lastMessage: String?, _ lastMessageDate: Date?, _ online: Bool?, _ hasUnreadMessages: Bool, _ isLastMessageByMe: Bool) {
        self.name = name
        self.userID = userID
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.isLastMessageByMe = isLastMessageByMe
    }
}
