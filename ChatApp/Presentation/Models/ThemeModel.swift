//
//  ThemeModel.swift
//  ChatApp
//
//  Created by Иван Лебедев on 05/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

class ThemeModel {
    
    private var themes = [UIColor.red, UIColor.white, UIColor.black]
    
    init() {}
    
    public func setTheme(number: Int, to: UIColor) {
        themes[number - 1] = to
    }
    
    public func getTheme(number: Int) -> UIColor {
        return themes[number - 1]
    }
}
