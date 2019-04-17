//
//  Protocols.swift
//  ChatApp
//
//  Created by Иван Лебедев on 17/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get set }
}

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
