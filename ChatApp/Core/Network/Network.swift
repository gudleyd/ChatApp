//
//  Requests.swift
//  ChatApp
//
//  Created by Иван Лебедев on 15/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

class Request: IRequest {
    var urlRequest: URLRequest?
    
    init(request: URLRequest?) {
        self.urlRequest = request
    }
}

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<Parser>(config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        let task = session.dataTask(with: urlRequest) { (data: Data?, _, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            guard let notNilData = data,
                let parsedModel: Parser.Model = config.parser.parse(data: notNilData) else {
                    completionHandler(Result.error("received data can't be parsed"))
                    return
            }
            completionHandler(Result.success(parsedModel))
        }
        task.resume()
    }
}
