//
//  ConversationsList+TableViewDataSource.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in FRC")
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in FRC")
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as? ChatTableViewCell else {
            print("No cell?")
            return UITableViewCell()
        }
        let data = self.fetchedResultsController.object(at: indexPath)
        cell.configure(name: data.user?.userName,
                       lastMessage: data.lastMessage,
                       isLastMessageByMe: data.isLastMessageByMe,
                       lastMessageDate: data.lastMessageDate ?? Date(),
                       online: data.isOnline,
                       hasUnreadMessages: data.hasUnreadMessages)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.fetchedResultsController.object(at: indexPath)
        let chatModel = ChatModel(name: data.user?.userName,
                                  userID: data.user?.userID ?? "No id",
                                  hasUnreadMessages: false)
        self.model.updateConversationHasUnreadMessages(userID: data.user?.userID ?? "No id",
                                                                  hasUnreadMessages: false)
        let convVC = self.assembly.getConversationViewController(with: chatModel)
        convVC.dataProvider = self.dataProvider
        self.navigationController?.pushViewController(convVC, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
