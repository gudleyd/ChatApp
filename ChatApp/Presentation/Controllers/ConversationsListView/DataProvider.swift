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

protocol IDataProvider: CommunicatorDelegate {
    func conversationsListFRC() -> NSFetchedResultsController<CDConversation>
    
    func conversationFRC(userID: String) -> NSFetchedResultsController<CDMessage>
    
    var listVC: ConversationsListViewController? { get set }
    var chatVC: ConversationViewController? { get set }
}

class DataProvider: IDataProvider {
    
    var storageManager: IStorageService!

    weak var listVC: ConversationsListViewController?
    weak var chatVC: ConversationViewController?

    func conversationsListFRC() -> NSFetchedResultsController<CDConversation> {
        let frc = NSFetchedResultsController(fetchRequest: CDConversation.requestSortedByDateConversations(),
                                             managedObjectContext: storageManager.mainContext,
                                             sectionNameKeyPath: "getSectionName", cacheName: nil)
        return frc
    }

    func conversationFRC(userID: String) -> NSFetchedResultsController<CDMessage> {
        let frc = NSFetchedResultsController(fetchRequest: CDMessage.requestMessagesInConversation(userID: userID),
                                             managedObjectContext: storageManager.mainContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    init(storageManager: IStorageService) {
        self.storageManager = storageManager
        storageManager.saveContext.performAndWait {
            do {
                let results = try (storageManager.saveContext.fetch(CDConversation.fetchRequest()) as? [CDConversation]) ?? []
                
                for conv in results {
                    conv.isOnline = false
                    conv.user?.isOnline = false
                }
                storageManager.performSave(in: storageManager.saveContext)
            } catch let err {
                print(err)
            }
        }
    }
}

extension DataProvider {
    func didFoundUser(userID: String, userName: String?) {
        let conv = storageManager.getOrInsertConversation(userID: userID, userName: userName ?? userID)
        storageManager.updateConversation(conv: conv, isOnline: true, completionHandler: nil)
    }

    func didLostUser(userID: String) {
        storageManager.updateConversation(conv: storageManager.getOrInsertConversation(userID: userID),
                                         isOnline: false,
                                         completionHandler: nil)
    }

    func failedToStartBrowsingForUsers(error: Error) {
        print("Failed to start Browsing")
    }

    func failedToStartAdvertising(error: Error) {
        print("Failed to start Advertising")
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        storageManager.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser, completionHandler: nil)
    }

    func stateChanged(displayName: String, state: MCSessionState) {
        if state != .connected {
            chatVC?.disableSendings()
        } else {
            chatVC?.enableSendings()
        }
    }

}
