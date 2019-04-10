//
//  StorageService.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import CoreData

protocol IStorageService {
    var stack: CoreDataStack! { get }
    
    var saveContext: NSManagedObjectContext { get }
    var mainContext: NSManagedObjectContext { get }
    
    func performSave(in context: NSManagedObjectContext)
    
    func saveUserProfile(profile: Profile, completion: (() -> Void)?)
    
    func updateUser(user: User?, isOnline: Bool?, completionHandler: (() -> Void)?)
    
    func updateConversation(conv: CDConversation?, isOnline: Bool?, completionHandler: (() -> Void)?)
    
    func getUserProfile() -> Profile
    
    func getOrInsertUser(userID: String, userName: String) -> User
    
    func getOrInsertConversation(userID: String, userName: String) -> CDConversation
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String, completionHandler: (() -> Void)?)
    
    func updateConversationHasUnreadMessages(userID: String, hasUnreadMessages: Bool)
}

extension IStorageService {
    func getOrInsertConversation(userID: String, userName: String = "") -> CDConversation {
        return getOrInsertConversation(userID: userID, userName: userName)
    }
}

extension IStorageService {
    func getOrInsertUser(userID: String, userName: String = "") -> User {
        return getOrInsertUser(userID: userID, userName: userName)
    }
}

class StorageService: IStorageService {
    
    var coreAssembly: ICoreAssembly
    var stack: CoreDataStack!
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
        self.stack = self.coreAssembly.storageManager.stack
    }
    
    var saveContext: NSManagedObjectContext {
        get {
            return self.coreAssembly.storageManager.saveContext
        }
    }
    
    var mainContext: NSManagedObjectContext {
        get {
            return self.coreAssembly.storageManager.mainContext
        }
    }
    
    func performSave(in context: NSManagedObjectContext) {
        self.coreAssembly.storageManager.performSave(in: context)
    }
    
    public func saveUserProfile(profile: Profile, completion: (() -> Void)?) {
        self.coreAssembly.storageManager.saveUserProfile(profile: profile, completion: completion)
    }
    
    public func updateUser(user: User?, isOnline: Bool?, completionHandler: (() -> Void)?) {
        self.coreAssembly.storageManager.updateUser(user: user, isOnline: isOnline, completionHandler: completionHandler)
    }
    
    public func updateConversation(conv: CDConversation?, isOnline: Bool?, completionHandler: (() -> Void)?) {
        self.coreAssembly.storageManager.updateConversation(conv: conv, isOnline: isOnline, completionHandler: completionHandler)
    }
    
    public func getUserProfile() -> Profile {
        return self.coreAssembly.storageManager.getUserProfile()
    }
    
    public func getOrInsertUser(userID: String, userName: String = "") -> User {
        return self.coreAssembly.storageManager.getOrInsertUser(userID: userID, userName: userName)
    }
    
    public func getOrInsertConversation(userID: String, userName: String = "") -> CDConversation {
        return self.coreAssembly.storageManager.getOrInsertConversation(userID: userID, userName: userName)
    }
    
    public func didReceiveMessage(text: String, fromUser: String, toUser: String, completionHandler: (() -> Void)?) {
        self.coreAssembly.storageManager.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser, completionHandler: completionHandler)
    }
    
    public func updateConversationHasUnreadMessages(userID: String, hasUnreadMessages: Bool) {
        self.coreAssembly.storageManager.updateConversationHasUnreadMessages(userID: userID, hasUnreadMessages: hasUnreadMessages)
    }
}
