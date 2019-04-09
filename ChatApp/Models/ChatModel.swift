//
//  ChatModel.swift
//  ChatApp
//
//  Created by Иван Лебедев on 22/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
class ChatModel {
    
    var name: String?
    var userID: String
    var hasUnreadMessages: Bool
    
    init(name: String?, userID: String, hasUnreadMessages: Bool) {
        self.name = name
        self.userID = userID
        self.hasUnreadMessages = hasUnreadMessages
    }
}
