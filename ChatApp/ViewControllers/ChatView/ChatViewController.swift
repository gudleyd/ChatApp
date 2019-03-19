//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 25/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    var chatModel: ChatModel? = nil
    @IBOutlet weak var tableView: UITableView!
    let accessoryView = UINib(nibName: "MessageInputAccessory", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MessageInputAccessoryView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib1 = UINib(nibName: "OutcomingMessageBubbleTableViewCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "OutcomingMessageBubbleTableViewCell")
        let nib2 = UINib(nibName: "IncomingMessageBubbleTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "IncomingMessageBubbleTableViewCell")
        
        chatModel?.hasUnreadMessages = false
        self.accessoryView.delegate = self
        
        if CommunicationManager.shared.communicator.session.connectedPeers.filter({$0.displayName == chatModel?.userID}).count != 0 {
            self.accessoryView.sendButton.isEnabled = true
        } else {
            CommunicationManager.shared.communicator.connectPeer(userID: chatModel!.userID)
            self.accessoryView.sendButton.isEnabled = false
        }
        
        setupObservers()
    }
    
    func enableSendings() {
        DispatchQueue.main.async {
            self.accessoryView.sendButton.isEnabled = true
        }
    }
    
    func disableSendings() {
        DispatchQueue.main.async {
            self.accessoryView.sendButton.isEnabled = false
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
        
        CommunicationManager.shared.communicator.disconnectPeers()
        MessageManager.shared.chatView = nil
        removeObservers()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatModel!.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageBubbleTableViewCell
        if chatModel!.messages[indexPath.row].fromMe {
            cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingMessageBubbleTableViewCell", for: indexPath) as! MessageBubbleTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageBubbleTableViewCell", for: indexPath) as! MessageBubbleTableViewCell
        }
        cell.configure(chatModel!.messages[indexPath.row].text, chatModel!.messages[indexPath.row].fromMe)
        return cell
    }
    
    
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController {
    
    func toBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatModel!.messages.count - 1, section: 0)
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
                })
            { [weak self] (_) in
                self?.toBottom()
            }
            
        }
    }
}

extension ChatViewController: MessageInput {
    func sendMessage(text: String!) {
        if (text.count != 0) {
            CommunicationManager.shared.communicator.sendMessage(text: text, to: chatModel!.userID) { (suc, err) in
                Debugger.shared.Print("Message not Sended")
            }
        }
    }
}
