//
//  ChatProtocol.swift
//  ChatApp
//
//  Created by Иван Лебедев on 22/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol ChatCellConfigurationProtocol: class {
    var name: String? {get set}
    var lastMessage: String? {get set}
    var lastMessageDate: Date? {get set}
    var online: Bool? {get set}
    var hasUnreadMessages: Bool {get set}
}
