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

    public func copy() -> Profile {
        return Profile(other: self)
    }
}
