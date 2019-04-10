//
//  MessageInputAccessoryView.swift
//  ChatApp
//
//  Created by Иван Лебедев on 19/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

protocol MessageInput: class {
    func sendMessage(text: String!)
}

class MessageInputAccessoryView: UIView {

    weak var delegate: MessageInput?

    @IBOutlet public var sendButton: UIButton!
    @IBOutlet public var textField: UITextField!
    @IBOutlet public weak var bottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }

    @objc func sendButtonTapped() {
        delegate?.sendMessage(text: textField.text)
    }
}
