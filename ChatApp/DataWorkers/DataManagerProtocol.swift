//
//  DataManagerProtocol.swift
//  ChatApp
//
//  Created by Иван Лебедев on 11/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import UIKit

protocol SaverDataManagerProtocol {
    static func saveData(data: Data!, filePath: String!, completionHandler: @escaping (Bool) -> ())
    static func saveString(str: String!, filePath: String!, encoding: String.Encoding, completionHandler: @escaping (Bool) -> (), async: Bool)
    static func saveImageAsPNG(img: UIImage!, filePath: String!, completionHandler: @escaping (Bool) -> (), async: Bool)
}

protocol LoaderDataManagerProtocol {
    static func loadData(filePath: String!, completionHandler: @escaping (Data) -> ())
    static func loadString(filePath: String!, completionHandler: @escaping (String) -> ())
    static func loadImage(filePath: String!, completionHandler: @escaping (UIImage) -> ())
}
