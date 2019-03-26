//
//  CoreDataStack.swift
//  ChatApp
//
//  Created by Иван Лебедев on 20/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    
    public static var shared = StorageManager()
    private var stack: CoreDataStack = CoreDataStack()
    
    public func saveUserProfile(profile: Profile, completion: (() ->())?) {
        var appUser: AppUser?
        appUser = AppUser.getAppUser(in: stack.saveContext)
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: stack.saveContext, name: "Ivan Lebedev")!
        }
        self.stack.saveContext.perform {
            appUser?.name = profile.name
            appUser?.status = profile.status
            appUser?.avatar = profile.avatar.pngData()
            self.stack.performSave(with: self.stack.saveContext, completion: completion)
        }
        
    }
    
    public func getUserProfile() -> Profile {
        var appUser: AppUser?
        appUser = AppUser.getAppUser(in: stack.mainContext)
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: stack.mainContext, name: "Ivan Lebedev")!
        }
        self.stack.performSave(with: stack.mainContext, completion: nil)
        let profile: Profile = Profile()
        profile.name = appUser?.name
        profile.status = appUser?.status
        profile.avatar = UIImage(data: appUser?.avatar ?? Data()) ?? UIImage(named: "placeholder-user")!
        return profile
    }
}
