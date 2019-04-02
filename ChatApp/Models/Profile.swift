//
//  Profile.swift
//  ChatApp
//
//  Created by Иван Лебедев on 12/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import UIKit

class Profile {

    var name: String?
    var namePath = "user-name.str"
    var status: String?
    var statusPath = "user-status.str"
    var avatar: UIImage = UIImage(named: "placeholder-user")!
    var avatarPath = "user-avatar.png"

    init() {}

    init(other: Profile) {
        self.name = other.name
        self.namePath = other.namePath
        self.status = other.status
        self.statusPath = other.statusPath
        self.avatar = other.avatar
        self.avatarPath = other.avatarPath
    }

    public func save(type: SavingType = .gcd, completionHandler: @escaping (Bool) -> Void = {_ in}) {
        if type == .gcd {
            DispatchQueue.init(label: "profile-saver").async {
                var oks: [Bool] = [false, false, false]
                let mainGroup = DispatchGroup()
                mainGroup.enter()
                GCDDocumentDataManager.saveString(str: self.name, filePath: self.namePath, encoding: .utf16, completionHandler: { (stat) in
                    mainGroup.leave()
                    oks[0] = stat
                })
                mainGroup.enter()
                GCDDocumentDataManager.saveString(str: self.status, filePath: self.statusPath, encoding: .utf16, completionHandler: { (stat) in
                    mainGroup.leave()
                    oks[1] = stat
                })
                mainGroup.enter()
                GCDDocumentDataManager.saveImageAsPNG(img: self.avatar, filePath: self.avatarPath, completionHandler: { (stat) in
                    mainGroup.leave()
                    oks[2] = stat
                })
                mainGroup.wait()
                completionHandler(oks == [true, true, true])
            }
        } else {
            let mainQueue = OperationQueue()
            mainQueue.addOperation({
                var oks: [Bool] = [false, false, false]
                let mainGroup = DispatchGroup()
                mainGroup.enter()
                OperationDataManager.saveString(str: self.name, filePath: self.namePath, encoding: .utf16, completionHandler: { (stat) in
                    mainGroup.leave()
                    oks[0] = stat
                })
                mainGroup.enter()
                OperationDataManager.saveString(str: self.status, filePath: self.statusPath, encoding: .utf16, completionHandler: { (stat) in
                    mainGroup.leave()
                    oks[1] = stat
                })
                mainGroup.enter()
                OperationDataManager.saveImageAsPNG(img: self.avatar, filePath: self.avatarPath, completionHandler: { (stat) in
                    mainGroup.leave()
                    oks[2] = stat
                })
                mainGroup.wait()
                completionHandler(oks == [true, true, true])
            })
        }
    }

    public func load(async: Bool = false, completionHandler: @escaping () -> Void = {}) {
        let mainGroup = DispatchGroup()
        mainGroup.enter()
        DispatchQueue.init(label: "profile-loader").async {
            mainGroup.enter()
            GCDDocumentDataManager.loadString(filePath: self.namePath, completionHandler: { (str) in self.name = str
                mainGroup.leave()
            })
            mainGroup.enter()
            GCDDocumentDataManager.loadString(filePath: self.statusPath, completionHandler: { (str) in self.status = str
                mainGroup.leave()
            })
            mainGroup.enter()
            GCDDocumentDataManager.loadImage(filePath: self.avatarPath, completionHandler: { (img) in self.avatar = img
                mainGroup.leave()
            })
            mainGroup.leave()
            if async { completionHandler() }
        }
        if !async { mainGroup.wait() }
    }

    public func copy() -> Profile {
        return Profile(other: self)
    }
}
