//
//  CoreDataExtensions.swift
//  ChatApp
//
//  Created by Иван Лебедев on 01/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import CoreData

extension AppUser {

    static func insertAppUser(in context: NSManagedObjectContext, name: String) -> AppUser? {
        guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else { return nil }
        appUser.name = name
        return appUser
    }

    static func getAppUser(in context: NSManagedObjectContext) -> AppUser? {
        let request = NSFetchRequest<AppUser>(entityName: "AppUser")
        request.returnsObjectsAsFaults = false
        var userToReturn: AppUser?
        context.performAndWait {
            do {
                let result = try context.fetch(request)
                if let appUser = result.first {
                    userToReturn = appUser
                }
            } catch let error {
                Debugger.shared.dbprint("getAppUser ERROR:\n\(error)")
            }
        }
        return userToReturn
    }
}

extension User {

    static func insertUser(in context: NSManagedObjectContext, userID: String, userName: String) -> User? {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else { return nil }
        user.userID = userID
        user.userName = userName
        return user
    }

    static func getUser(in context: NSManagedObjectContext, with userID: String) -> User? {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userID == %@", userID)
        request.returnsObjectsAsFaults = false
        var userToReturn: User?
        context.performAndWait {
            do {
                let result = try context.fetch(request)
                if let user = result.first {
                    userToReturn = user
                }
            } catch let error {
                Debugger.shared.dbprint("getUser ERROR:\n\(error)")
            }
        }
        return userToReturn
    }
}

extension CDMessage {

    static func insertMessage(in context: NSManagedObjectContext, text: String, fromMe: Bool, date: Date) -> CDMessage? {
        var message: CDMessage?
        context.performAndWait {
            guard let tmpMessage = NSEntityDescription.insertNewObject(
                forEntityName: "CDMessage",
                into: context) as? CDMessage else { return }
            message = tmpMessage
            message?.text = text
            message?.fromMe = fromMe
            message?.date = date
        }
        return message
    }

    static func requestMessagesInConversation(userID: String) -> NSFetchRequest<CDMessage> {
        let request: NSFetchRequest<CDMessage> = CDMessage.fetchRequest()
        request.predicate = NSPredicate(format: "conversation.user.userID == %@", userID)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }
}

extension CDConversation {

    @objc func getSectionName() -> String {
        return self.isOnline ? "Онлайн" : "Оффлайн"
    }

    static func insertConversation(in context: NSManagedObjectContext, user: User) -> CDConversation? {
        var conversation: CDConversation?
        context.performAndWait {
            guard let tmpConversation = NSEntityDescription.insertNewObject(
                forEntityName: "CDConversation",
                into: context) as? CDConversation else { return }
            conversation = tmpConversation
            conversation?.user = user
            conversation?.hasUnreadMessages = false
            conversation?.isLastMessageByMe = false
        }
        return conversation
    }

    static func getConversation(in context: NSManagedObjectContext, userID: String) -> CDConversation? {
        let request = NSFetchRequest<CDConversation>(entityName: "CDConversation")
        request.predicate = NSPredicate(format: "user.userID == %@", userID)
        request.returnsObjectsAsFaults = false
        var conversationToReturn: CDConversation?
        context.performAndWait {
            do {
                let result = try context.fetch(request)
                if let conversation = result.first {
                    conversationToReturn = conversation
                }
            } catch let error {
                Debugger.shared.dbprint("getUser ERROR:\n\(error)")
            }
        }
        return conversationToReturn
    }

    static func requestConversation(userID: String) -> NSFetchRequest<CDConversation> {
        let request: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        request.predicate = NSPredicate(format: "user.userID == %@", userID)
        return request
    }

    static func requestOnlineConversation() -> NSFetchRequest<CDConversation> {
        let request: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        request.predicate = NSPredicate(format: "user.isOnline == TRUE")
        return request
    }

    static func requestSortedByDateConversations() -> NSFetchRequest<CDConversation> {
        let request: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isOnline", ascending: false), NSSortDescriptor(key: "lastMessageDate", ascending: false)]
        return request
    }
}
