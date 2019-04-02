//
//  DataProvider.swift
//  ChatApp
//
//  Created by Иван Лебедев on 02/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import CoreData
import MultipeerConnectivity

class DataProvider {

    weak var listVC: ConversationsListViewController?
    weak var chatVC: ChatViewController?

    func conversationsListFRC() -> NSFetchedResultsController<CDConversation> {
        let frc = NSFetchedResultsController(fetchRequest: CDConversation.requestSortedByDateConversations(),
                                             managedObjectContext: StorageManager.shared.mainContext,
                                             sectionNameKeyPath: "getSectionName", cacheName: nil)
        return frc
    }

    func conversationFRC(userID: String) -> NSFetchedResultsController<CDMessage> {
        let frc = NSFetchedResultsController(fetchRequest: CDMessage.requestMessagesInConversation(userID: userID),
                                             managedObjectContext: StorageManager.shared.mainContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    init() {
        
    }
}

extension DataProvider: CommunicatorDelegate {
    func didFoundUser(userID: String, userName: String?) {
        let conv = StorageManager.shared.getOrInsertConversation(userID: userID, userName: userName ?? userID)
        StorageManager.shared.updateConv(conv: conv, isOnline: true, completionHandler: { self.listVC?.updateTable() })
        StorageManager.shared.updateUser(user: conv.user, isOnline: true, completionHandler: {
            self.listVC?.updateTable()
            self.chatVC?.enableSendings()
        })
    }

    func didLostUser(userID: String) {
        StorageManager.shared.updateConv(conv: StorageManager.shared.getOrInsertConversation(userID: userID),
                                         isOnline: true,
                                         completionHandler: {self.listVC?.updateTable() })
        StorageManager.shared.updateUser(user: StorageManager.shared.getOrInsertUser(userID: userID), isOnline: false, completionHandler: {
            self.listVC?.updateTable()
            self.chatVC?.disableSendings()
        })
    }

    func failedToStartBrowsingForUsers(error: Error) {
        // Nothing here
        print("Failed to start Browsing")
    }

    func failedToStartAdvertising(error: Error) {
        // Nothing here
        print("Failed to start Advertising")
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        StorageManager.shared.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser, completionHandler: { self.chatVC?.reloadMessages() })
    }

    func stateChanged(displayName: String, state: MCSessionState) {
        if state != .connected {
            chatVC?.disableSendings()
        } else {
            chatVC?.enableSendings()
        }
    }

}
