//
//  Requests.swift
//  ChatApp
//
//  Created by Иван Лебедев on 15/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct PixabayConfig {
        
        static var apiKey: String = "12205119-b00c5fecd4286819f7f1a6289"
        static var imageCount: Int = 100
        
        static func standardAPIRequest() -> String {
            return "https://pixabay.com/api/"
        }
        static func AvatarsListRequest() -> RequestConfig<ImagesParser> {
            var urlString: String = self.standardAPIRequest()
            urlString += "?key=\(self.apiKey)"
            urlString += "&q=skyline"
            urlString += "&image_type=photo"
            urlString += "&pretty=true"
            urlString += "&per_page=\(imageCount)"
            guard let url: URL = URL(string: urlString) else {
                fatalError("Wrong url for PixabayConfig::AvatarsListRequest")
            }
            let request: IRequest = Request(request: URLRequest(url: url))
            return RequestConfig<ImagesParser>(request: request, parser: ImagesParser())
        }
    }
}
