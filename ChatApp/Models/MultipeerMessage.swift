//
//  Message.swift
//  ChatApp
//
//  Created by Иван Лебедев on 18/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

func generateMessageId() -> String {
    let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
    return string!
}

class MultipeerMessage: Codable {
    var eventType: String
    var messageId: String
    var text: String

    init(text: String) {
        self.eventType = "TextMessage"
        self.messageId = generateMessageId()
        self.text = text
    }

    init(eventType: String = "TextMessage", messageId: String, text: String) {
        self.eventType = eventType
        self.messageId = messageId
        self.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        self.eventType = (aDecoder.decodeObject(forKey: "eventType") as? String) ?? "TestMessage"
        self.messageId = (aDecoder.decodeObject(forKey: "messageId") as? String) ?? "NO ID"
        self.text = (aDecoder.decodeObject(forKey: "text") as? String) ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(eventType, forKey: "eventType")
        aCoder.encode(messageId, forKey: "messageId")
        aCoder.encode(text, forKey: "text")
    }
}
