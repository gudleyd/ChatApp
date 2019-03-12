//
//  GCDDataManager.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import UIKit

func getBaseURL() throws -> URL {
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        fatalError("There is no Document Directory??!")
    }
    return url
}

class GCDDocumentDataManager : SaverDataManagerProtocol {
    
    public static func saveData(data: Data!, filePath: String!, completionHandler: @escaping (Bool) -> () = {_ in}) {
        DispatchQueue.init(label: "docs://" + filePath, qos: .userInitiated).async {
            do {
                try data.write(to: getBaseURL().appendingPathComponent(filePath), options: .atomic)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
    }
    
    public static func saveString(str: String!, filePath: String!, encoding: String.Encoding, completionHandler: @escaping (Bool) -> () = {_ in}, async: Bool = false) {
        saveData(data: str.data(using: encoding), filePath: filePath, completionHandler: completionHandler)
    }
    
    public static func saveImageAsPNG(img: UIImage!, filePath: String!, completionHandler: @escaping (Bool) -> () = {_ in}, async: Bool = false) {
        saveData(data: img.pngData(), filePath: filePath, completionHandler: completionHandler)
    }
    
    public static func loadData(filePath: String!, completionHandler: @escaping (Data) -> () = {_ in}) {
        DispatchQueue.init(label: "docs://" + filePath, qos: .userInitiated).async {
            let data = try? Data.init(contentsOf: getBaseURL().appendingPathComponent(filePath))
            completionHandler(data ?? Data())
        }
    }
    
    public static func loadString(filePath: String!, completionHandler: @escaping (String) -> () = {_ in}) {
        DispatchQueue.init(label: "docs://" + filePath, qos: .userInitiated).async {
            let string = try? String.init(contentsOf: getBaseURL().appendingPathComponent(filePath))
            completionHandler(string ?? "")
        }
    }
    
    public static func loadImage(filePath: String!, completionHandler: @escaping (UIImage) -> () = {_ in}) {
        loadData(filePath: filePath, completionHandler: { (data) in
            completionHandler(UIImage(data: data) ?? UIImage(named: "default-image")!)
        })
    }
    
}

class OperationDataManager : SaverDataManagerProtocol {
    
    static private let mainQueue = OperationQueue()
    
    static public func saveData(data: Data!, filePath: String!, completionHandler: @escaping (Bool) -> ()) {
        let operation = {
            do {
                try data.write(to: getBaseURL().appendingPathComponent(filePath), options: .atomic)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
        OperationDataManager.mainQueue.addOperation(operation)
    }
    
    static public func saveString(str: String!, filePath: String!, encoding: String.Encoding, completionHandler: @escaping (Bool) -> () = {_ in}, async: Bool = false) {
        saveData(data: str.data(using: encoding), filePath: filePath, completionHandler: completionHandler)
    }
    
    static public func saveImageAsPNG(img: UIImage!, filePath: String!, completionHandler: @escaping (Bool) -> () = {_ in}, async: Bool = false) {
        saveData(data: img.pngData(), filePath: filePath, completionHandler: completionHandler)
    }
}

enum SavingType {
    case gcd, operation
}
