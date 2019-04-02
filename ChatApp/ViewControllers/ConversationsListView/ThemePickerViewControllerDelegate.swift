//
//  ThemePickerViewControllerDelegate.swift
//  ChatApp
//
//  Created by Иван Лебедев on 05/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import UIKit

extension ConversationsListViewController {

    func logThemeChanging(_ newTheme: UIColor) {
        Debugger.shared.dbprint("Selected new theme with color: \(newTheme)")
    }

    func isLight(_ theme: UIColor) -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        theme.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return ((red * 299) + (green * 587) + (blue * 114)) / 1000 > 0.49
    }

    func setTheme(_ newTheme: UIColor) {
        logThemeChanging(newTheme)

        self.navigationController?.navigationBar.barStyle = (isLight(newTheme) ? UIBarStyle.default : UIBarStyle.black)

        UserDefaults.saveTheme(theme: newTheme)

        UINavigationBar.appearance().barTintColor = newTheme
        self.navigationController?.navigationBar.barTintColor = newTheme

        let textColor = (isLight(newTheme) ? UIColor.black : UIColor.white)
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
    }

}
