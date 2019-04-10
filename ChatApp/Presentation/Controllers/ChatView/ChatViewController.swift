//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 25/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConversationViewController: UIViewController {

    var chatModel: ChatModel?
    weak var dataProvider: DataProvider?

    @IBOutlet internal weak var tableView: UITableView!
    
    let accessoryView = UINib(nibName: "MessageInputAccessory",
                              bundle: nil)
        .instantiate(withOwner: nil, options: nil)[0] as? MessageInputAccessoryView

    var fetchedResultsController: NSFetchedResultsController<CDMessage>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if let dp = dataProvider {
            fetchedResultsController = {
                let frc = dp.conversationFRC(userID: chatModel?.userID ?? "No id")
                frc.delegate = self
                do {
                    try frc.performFetch()
                } catch let err {
                    print("Cant fetch in ConversationListVC")
                    print(err)
                }
                return frc
            }()
        }

        let nib1 = UINib(nibName: "OutcomingMessageBubbleTableViewCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "OutcomingMessageBubbleTableViewCell")
        let nib2 = UINib(nibName: "IncomingMessageBubbleTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "IncomingMessageBubbleTableViewCell")

        chatModel?.hasUnreadMessages = false
        self.accessoryView?.delegate = self

        if CommunicationManager.shared.communicator.session.connectedPeers.filter({$0.displayName == chatModel?.userID}).count != 0 {
            self.accessoryView?.sendButton.isEnabled = true
        } else {
            CommunicationManager.shared.communicator.connectPeer(userID: chatModel?.userID ?? "")
            self.accessoryView?.sendButton.isEnabled = false
        }

        setupObservers()
    }

    func enableSendings() {
        DispatchQueue.main.async {
            self.accessoryView?.sendButton.isEnabled = true
        }
    }

    func disableSendings() {
        DispatchQueue.main.async {
            self.accessoryView?.sendButton.isEnabled = false
        }
    }

    func reloadMessages() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.toBottom()
        }
    }

    override var inputAccessoryView: UIView? {
        get {
            return accessoryView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StorageManager.shared.updateConversationHasUnreadMessages(userID: chatModel?.userID ?? "No id", hasUnreadMessages: false)

        CommunicationManager.shared.communicator.disconnectPeers()
        removeObservers()
    }

}

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

extension ConversationViewController: UITableViewDelegate {

}

extension ConversationViewController {

    func toBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: (self.fetchedResultsController.fetchedObjects?.count ?? 0) - 1, section: 0)
            if indexPath.row >= 0 {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func onShowKeyboard(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            UIView.animate(withDuration: 0.6, animations: { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 10, right: 0)
                    self?.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardHeight + 10, right: 0)
                }
                }) { [weak self] _ in
                self?.toBottom()
            }
        }
    }
}

extension ConversationViewController: MessageInput {
    func sendMessage(text: String!) {
        if text.count != 0 {
            CommunicationManager.shared.communicator.sendMessage(text: text, to: chatModel?.userID ?? "") { (_, _) in
                Debugger.shared.dbprint("Message not Sended")
            }
            DispatchQueue.main.async {
                self.accessoryView?.textField.text = ""
            }
        }
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        tableView.reloadSectionIndexTitles()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let nip = newIndexPath {
                tableView.insertRows(at: [nip], with: .automatic)
            }
        case .move:
            if let nip = newIndexPath,
                let ip = indexPath {
                tableView.deleteRows(at: [ip], with: .automatic)
                tableView.insertRows(at: [nip], with: .automatic)
            }
        case .update:
            if let ip = indexPath {
                tableView.reloadRows(at: [ip], with: .automatic)
            }
        case .delete:
            if let ip = indexPath {
                tableView.deleteRows(at: [ip], with: .automatic)
            }
        }
        self.toBottom()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
        self.toBottom()
    }
}
