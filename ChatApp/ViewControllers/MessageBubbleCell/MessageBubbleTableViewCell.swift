//
//  MessageBubbleTableViewCell.swift
//  ChatApp
//
//  Created by Иван Лебедев on 25/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

class MessageBubbleTableViewCell: UITableViewCell, MessageCellConfigurationProtocol {

    var messageText: String? = nil
    var isOutcome: Bool = false
    var setups: Int = 0
    
    @IBOutlet private var messageTextLabel: UILabel!
    @IBOutlet private var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ with: String, _ isOutcome: Bool = false) {
        self.messageText = with
        self.isOutcome = isOutcome
        setup()
    }
    
    func setup() {
        let GOEConstraint = self.contentView.constraints.filter { $0.identifier == "left" || $0.identifier == "right" }
        GOEConstraint[0].constant = self.frame.width * 1/4
        messageTextLabel.text = messageText
        self.background.layer.cornerRadius = 8
        if isOutcome {
            self.background.backgroundColor = UIColor(red: 200/255, green: 233/255, blue: 160/255, alpha: 1)
        } else {
            self.background.backgroundColor = UIColor(red: 102/255, green: 155/255, blue: 200/255, alpha: 1)
        }
    }
}
