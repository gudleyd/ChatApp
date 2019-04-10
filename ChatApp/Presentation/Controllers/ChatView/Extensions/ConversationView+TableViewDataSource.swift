//
//  ConversationView+TableViewDataSource.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in FRC")
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageBubbleTableViewCell
        let object = self.fetchedResultsController.object(at: indexPath)
        if object.fromMe {
            guard let tmp = tableView.dequeueReusableCell(
                withIdentifier: "OutcomingMessageBubbleTableViewCell",
                for: indexPath) as? MessageBubbleTableViewCell else {
                    print("No MessageBubbleCell?")
                    return UITableViewCell()
            }
            cell = tmp
        } else {
            guard let tmp = tableView.dequeueReusableCell(
                withIdentifier: "IncomingMessageBubbleTableViewCell",
                for: indexPath) as? MessageBubbleTableViewCell else {
                    print("No MessageBubbleCell?")
                    return UITableViewCell()
            }
            cell = tmp
        }
        cell.configure(object.text ?? "No Message Text", object.fromMe)
        return cell
    }
    
}
