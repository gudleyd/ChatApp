//
//  PixbayParsers.swift
//  ChatApp
//
//  Created by Иван Лебедев on 15/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

struct PBImage: Codable {
    var previewURL: String
    var largeImageURL: String
    var webformatHeight: Int
    var webformatWidth: Int
}

struct PBImagesList: Codable {
    var totalHits: Int
    var hits: [PBImage]
}

class ImagesParser: IParser {
    
    typealias Model = [PBImage]
    
    func parse(data: Data) -> [PBImage]? {
        var images: [PBImage]? = []
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
            return nil
        }
        guard let hits = json["hits"] as? [[String: Any]] else {
            return nil
        }
        for object in hits {
            images?.append(PBImage(previewURL: (object["previewURL"] as? String) ?? "",
                                   largeImageURL: (object["largeImageURL"] as? String) ?? "",
                                   webformatHeight: (object["webformatHeight"] as? Int) ?? -1,
                                   webformatWidth: (object["webformatWidth"] as? Int) ?? -1))
        }
        return images
    }
}
