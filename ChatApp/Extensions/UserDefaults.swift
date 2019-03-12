//
//  UserDefaults.swift
//  ChatApp
//
//  Created by Иван Лебедев on 05/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    
    static func saveTheme(theme: UIColor) {
        DispatchQueue.init(label: "theme-queue").async {
            let data = NSKeyedArchiver.archivedData(withRootObject: theme)
            UserDefaults.standard.set(data, forKey: "themeColor")
        }
    }
    
    static func loadTheme() -> UIColor {
        var theme: UIColor?
        DispatchQueue.init(label: "theme-queue").async {
            let data = UserDefaults.standard.data(forKey: "themeColor")
            theme =  NSKeyedUnarchiver.unarchiveObject(with: data ?? Data()) as? UIColor ?? UIColor.white
        }
        return theme ?? UIColor.white
    }
}
