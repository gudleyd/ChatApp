//
//  CoreDataStack.swift
//  ChatApp
//
//  Created by Иван Лебедев on 20/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation
import CoreData

protocol IBaseStorageManager {
    var stack: CoreDataStack { get }
    
    var mainContext: NSManagedObjectContext { get }
    
    var saveContext: NSManagedObjectContext { get }
    
    func performSave(in context: NSManagedObjectContext)
}

protocol IUserProfileStorageManager {
    func saveUserProfile(profile: Profile, completion: (() -> Void)?)
    
    func getUserProfile() -> Profile
}

protocol IMessageStorageManager {
    func didReceiveMessage(text: String, fromUser: String, toUser: String, completionHandler: (() -> Void)?)
}

protocol IUserStorageManager {
    func getOrInsertUser(userID: String, userName: String) -> User
    
    func updateUser(user: User?, isOnline: Bool?, completionHandler: (() -> Void)?)
}

extension IUserStorageManager {
    func getOrInsertUser(userID: String, userName: String = "") -> User {
        return getOrInsertUser(userID: userID, userName: userName)
    }
}

protocol IConversationStorageManager {
    func getOrInsertConversation(userID: String, userName: String) -> CDConversation
    
    func updateConversation(conv: CDConversation?, isOnline: Bool?, completionHandler: (() -> Void)?)
    
    func updateConversationHasUnreadMessages(userID: String, hasUnreadMessages: Bool)
}

extension IConversationStorageManager {
    func getOrInsertConversation(userID: String, userName: String = "") -> CDConversation {
        return getOrInsertConversation(userID: userID, userName: userName)
    }
}

protocol IStorageManager: IBaseStorageManager, IUserProfileStorageManager, IMessageStorageManager,
    IUserStorageManager, IConversationStorageManager {
    
}

class StorageManager: IStorageManager {
    
    init() {}
    
    internal var stack: CoreDataStack = CoreDataStack()

    var saveContext: NSManagedObjectContext {
        get {
            return self.stack.saveContext
        }
    }

    var mainContext: NSManagedObjectContext {
        get {
            return self.stack.mainContext
        }
    }

    func performSave(in context: NSManagedObjectContext) {
        DispatchQueue.global(qos: .background).async {
            self.stack.performSave(with: context)
        }
    }

    public func saveUserProfile(profile: Profile, completion: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            var appUser: AppUser?
            appUser = AppUser.getAppUser(in: self.stack.saveContext)
            if appUser == nil {
                appUser = AppUser.insertAppUser(in: self.stack.saveContext, name: "Ivan Lebedev")
            }
            self.stack.saveContext.perform {
                appUser?.name = profile.name
                appUser?.status = profile.status
                appUser?.avatar = profile.avatar.pngData()
                self.stack.performSave(with: self.stack.saveContext, completion: completion)
            }
        }
    }

    public func updateUser(user: User?, isOnline: Bool?, completionHandler: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            if let user = user {
                user.managedObjectContext?.performAndWait {
                    if let online = isOnline {
                        user.isOnline = online
                    }
                    DispatchQueue.main.async {
                        if let context = user.managedObjectContext {
                            self.stack.performSave(with: context)
                        }
                        completionHandler?()
                    }
                }
            }
        }
    }
    
    public func updateConversation(conv: CDConversation?, isOnline: Bool?, completionHandler: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            if let conv = conv {
                conv.managedObjectContext?.performAndWait {
                    if let online = isOnline {
                        conv.isOnline = online
                    }
                    DispatchQueue.main.async {
                        if let context = conv.managedObjectContext {
                            self.stack.performSave(with: context)
                        }
                        completionHandler?()
                    }
                }
            }
        }
    }

    public func getUserProfile() -> Profile {
        var appUser: AppUser?
        appUser = AppUser.getAppUser(in: stack.mainContext)
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: stack.mainContext, name: "Ivan Lebedev")
        }
        self.stack.performSave(with: stack.mainContext, completion: nil)
        let profile: Profile = Profile()
        profile.name = appUser?.name
        profile.status = appUser?.status
        profile.avatar = UIImage(data: appUser?.avatar ?? Data()) ?? UIImage(named: "placeholder-user") ?? UIImage()
        return profile
    }

    public func getOrInsertUser(userID: String, userName: String = "") -> User {
        var user: User?
        user = User.getUser(in: stack.mainContext, with: userID)
        if user == nil {
            user = User.insertUser(in: stack.mainContext, userID: userID, userName: userName)
            self.stack.performSave(with: stack.mainContext, completion: nil)
        }
        guard let userToReturn = user else {
            fatalError()
        }
        return userToReturn
    }

    public func getOrInsertConversation(userID: String, userName: String = "") -> CDConversation {
        var conv: CDConversation?
        conv = CDConversation.getConversation(in: stack.mainContext, userID: userID)
        if conv == nil {
            var user: User?
            user = User.getUser(in: stack.mainContext, with: userID)
            if user == nil {
                user = User.insertUser(in: stack.mainContext, userID: userID, userName: userName)
                self.stack.performSave(with: stack.mainContext, completion: nil)
            }
            guard let mUser = user else { fatalError() }
            conv = CDConversation.insertConversation(in: stack.mainContext, user: mUser)
            self.stack.performSave(with: stack.mainContext, completion: nil)
        }
        guard let convToReturn = conv else { fatalError() }
        return convToReturn
    }

    public func didReceiveMessage(text: String, fromUser: String, toUser: String, completionHandler: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            var conv = CDConversation.getConversation(in: self.saveContext, userID: fromUser)
            var fromMe = false
            if conv == nil {
                conv = CDConversation.getConversation(in: self.saveContext, userID: toUser)
                fromMe = true
            }
            if let message = CDMessage.insertMessage(in: self.stack.saveContext, text: text, fromMe: fromMe, date: Date()) {
                conv?.managedObjectContext?.performAndWait {
                    conv?.lastMessage = text
                    conv?.lastMessageDate = Date()
                    conv?.isLastMessageByMe = fromMe
                    conv?.hasUnreadMessages = true
                    conv?.addToMessages(message)
                }
            }
            DispatchQueue.main.async {
                self.stack.performSave(with: self.saveContext)
                completionHandler?()
            }
        }
    }
    
    public func updateConversationHasUnreadMessages(userID: String, hasUnreadMessages: Bool) {
        DispatchQueue.global(qos: .background).async {
            let conv = CDConversation.getConversation(in: self.saveContext, userID: userID)
            conv?.managedObjectContext?.performAndWait {
                conv?.hasUnreadMessages = hasUnreadMessages
            }
            DispatchQueue.main.async {
                self.stack.performSave(with: self.saveContext)
            }
        }
    }
}
