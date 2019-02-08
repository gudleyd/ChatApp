//
//  service.swift
//  ChatApp
//
//  Created by Иван Лебедев on 07/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation

let DEBUG: Bool = true

func ifDebugPrint(_ toPrint: Any) -> Void {
    if (!DEBUG) { return }
    print(toPrint)
}
