//
//  ConversationTableViewCell.swift
//  ChatApp
//
//  Created by Иван Лебедев on 22/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var unreadMessagesLabel: UILabel!

    var name: String?
    var lastMessage: String?
    var lastMessageDate: Date?
    var online: Bool?
    var hasUnreadMessages: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        unreadMessagesLabel.layer.masksToBounds = true
        unreadMessagesLabel.layer.cornerRadius = unreadMessagesLabel.frame.height / 2
        unreadMessagesLabel.backgroundColor = UIColor.cyan

        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
        profileImageView.image = UIImage(named: "placeholder-user")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(name: String?, lastMessage: String?, isLastMessageByMe: Bool, lastMessageDate: Date, online: Bool, hasUnreadMessages: Bool) {
        self.name = name
        self.lastMessage = lastMessage
        if isLastMessageByMe {
            self.lastMessage = "Вы: " + (lastMessage ?? "")
        }
        self.lastMessageDate = lastMessageDate
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages

        setup()
    }

    func setup() {

        nameLabel.text = (name ?? "")

        if let date = lastMessageDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "ru")
            let calender = Calendar.current
            let currentDateComponents = calender.dateComponents(Set<Calendar.Component>(arrayLiteral: .day, .month, .year), from: Date())
            let lastMessageDateComponents = calender.dateComponents(Set<Calendar.Component>(arrayLiteral: .day, .month, .year), from: date)

            dateFormatter.dateFormat = "dd MMM yyyy"
            if lastMessageDateComponents.year == currentDateComponents.year {
                dateFormatter.dateFormat = "dd MMM"
                if lastMessageDateComponents.month == currentDateComponents.month &&
                    lastMessageDateComponents.day == currentDateComponents.day {
                    dateFormatter.dateFormat = "HH:mm"
                }
            }
            self.lastMessageDateLabel.text = dateFormatter.string(from: date)
        } else {
            lastMessageDateLabel.text = ""
        }

        if online ?? false {
            self.backgroundColor = UIColor(red: 127/255, green: 255/255, blue: 0/255, alpha: 0.1)
        } else {
            self.backgroundColor = UIColor.white
        }

        if let text = lastMessage {
            lastMessageLabel.text = text
            lastMessageLabel.font = UIFont(name: "System Font", size: 12)
            lastMessageLabel.textColor = UIColor.black
        } else {
            lastMessageLabel.text = "Нет Сообщений"
            lastMessageLabel.font = UIFont(name: "Open Sans", size: 20)
            lastMessageLabel.textColor = UIColor.red
            hasUnreadMessages = false
        }

        unreadMessagesLabel.isHidden = !hasUnreadMessages
    }
}
