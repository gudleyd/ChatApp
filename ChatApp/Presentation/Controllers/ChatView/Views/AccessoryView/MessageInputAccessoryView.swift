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
        sendButton.setTitleColor(UIColor.white, for: .normal)
        self.sendButton.backgroundColor = UIColor.lightGray
    }

    @objc func sendButtonTapped() {
        delegate?.sendMessage(text: textField.text)
    }
    
    public func animate(isOn: Bool) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [],
                       animations: {
            self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            if isOn {
                self.sendButton.backgroundColor = UIColor(red: 135.0/255.0, green: 206.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            } else {
                self.sendButton.backgroundColor = UIColor.lightGray
            }
        }, completion: { (_) in
            UIView.animate(withDuration: 0.3,
                           delay: 0.5,
                           animations: {
                            self.sendButton.transform = .identity
            }, completion: nil)
        })
    }
}
