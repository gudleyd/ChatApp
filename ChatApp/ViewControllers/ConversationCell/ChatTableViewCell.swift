//
//  ConversationTableViewCell.swift
//  ChatApp
//
//  Created by Иван Лебедев on 22/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell, ChatCellConfigurationProtocol {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    
    var name: String? = nil
    var lastMessage: String? = nil
    var lastMessageDate: Date? = nil
    var online: Bool? = nil
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
    
    func configure(from: ChatModel) {
        name = from.name
        lastMessage = from.lastMessage
        if from.isLastMessageByMe {
            lastMessage = "Вы: " + (lastMessage ?? "")
        }
        lastMessageDate = from.lastMessageDate
        online = from.online
        hasUnreadMessages = from.hasUnreadMessages
        
        
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
        
        unreadMessagesLabel.isHidden = !hasUnreadMessages
        
        if online ?? false {
            self.backgroundColor = UIColor(red: 127/255, green: 255/255, blue: 0/255, alpha: 0.1)
        } else {
            self.backgroundColor = UIColor.white
        }
        
        if let text = lastMessage {
            lastMessageLabel.text = text
        } else {
            lastMessageLabel.text = "Нет Сообщений"
            lastMessageLabel.font = UIFont(name: "Open Sans", size: 20)
            lastMessageLabel.textColor = UIColor.red
        }
    }
}
