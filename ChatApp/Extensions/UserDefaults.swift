//
//  UserDefaults.swift
//  ChatApp
//
//  Created by Иван Лебедев on 05/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static func saveTheme(theme: UIColor) {
        let data = NSKeyedArchiver.archivedData(withRootObject: theme)
        UserDefaults.standard.set(data, forKey: "themeColor")
    }
    
    static func loadTheme() -> UIColor {
        guard let data = UserDefaults.standard.data(forKey: "themeColor") else { return UIColor.white }
        guard let theme = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor else { return UIColor.white }
        return theme
    }
}
