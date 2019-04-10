//
//  ConversationView+MessageInput.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

extension ConversationViewController: MessageInput {
    func sendMessage(text: String!) {
        if text.count != 0 {
            self.model.sendMessage(text: text, to: chatModel?.userID ?? "") { (success, _) in
                if !success { Debugger.shared.dbprint("Message not Sended") }
            }
            DispatchQueue.main.async {
                self.accessoryView?.textField.text = ""
            }
        }
    }
}
