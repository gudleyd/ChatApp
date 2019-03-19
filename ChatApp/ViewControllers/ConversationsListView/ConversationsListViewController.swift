//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 21/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ConversationsListViewController : UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var allChats: [ChatModel] = []
    var onlineChats: [ChatModel] = []
    var offlineChats: [ChatModel] = []
    
    enum Sections : Int {
        case online = 0
        case offline = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTheme(UserDefaults.loadTheme())
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = 80
        
        let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatTableViewCell")
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        searchController.searchBar.delegate!.searchBar?(searchController.searchBar, textDidChange: "")
        
        splitChats()
        
        let mainGroup = DispatchGroup()
        mainGroup.enter()
        GCDDocumentDataManager.loadString(filePath: "user-name.str", completionHandler: { (str) in
            MessageManager.shared = MessageManager(userName: str)
            MessageManager.shared.listView = self
            mainGroup.leave()
        })
        mainGroup.wait()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateTable()
    }
    
    func splitChats() {
        onlineChats = allChats.filter({$0.online ?? false})
        onlineChats.sort(by: {(cm1, cm2) in
            if cm1.lastMessageDate != nil && cm2.lastMessageDate != nil && cm1.lastMessageDate! != cm2.lastMessageDate! {
                return cm1.lastMessageDate! > cm2.lastMessageDate!
            } else {
                return cm1.name! < cm2.name!
            }
        })
        offlineChats = allChats.filter({!($0.online ?? false)})
        offlineChats.sort(by: {(cm1, cm2) in
            if cm1.lastMessageDate == nil && cm2.lastMessageDate != nil {
                return false;
            } else if cm1.lastMessageDate != nil && cm2.lastMessageDate == nil {
                return true
            } else if cm1.lastMessageDate != nil && cm2.lastMessageDate != nil {
                if cm1.lastMessageDate! != cm2.lastMessageDate! {
                    return cm1.lastMessageDate! > cm2.lastMessageDate!
                } else {
                    if cm1.name != nil && cm2.name != nil {
                        return cm1.name! < cm2.name!
                    } else {
                        return true
                    }
                }
            } else {
                if cm1.name != nil && cm2.name != nil {
                    return cm1.name! < cm2.name!
                } else {
                    return true
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToChatView" {
            let chatModel = sender as? ChatModel
            let obj = segue.destination as! ChatViewController
            obj.title = (chatModel?.name ?? "Unknown")
            obj.chatModel = chatModel
            MessageManager.shared.chatView = obj
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction func themePickerOpenButtonClicked(_ sender: Any) {
        let sThemePickerViewController = SThemePickerViewController(closure: {
            [weak self] theme in
            self?.setTheme(theme)
        });
        self.present(sThemePickerViewController, animated: true, completion: nil);
    }
    
    func updateTable() {
        DispatchQueue.main.async {
            self.splitChats()
            self.tableView.reloadData()
        }
    }
}


extension ConversationsListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0 ? onlineChats.count > 0 ? "Онлайн" : "Оффлайн" : "Оффлайн")
    }
}

extension ConversationsListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (min(1, onlineChats.count) + min(1, offlineChats.count))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.online.rawValue && onlineChats.count > 0 {
            return onlineChats.count
        } else {
            return offlineChats.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        if indexPath.section == Sections.online.rawValue && onlineChats.count > 0 {
            cell.configure(from: onlineChats[indexPath.row])
        } else {
            cell.configure(from: offlineChats[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chatModel: ChatModel?
        if indexPath.section == 0 && onlineChats.count > 0 {
            chatModel = onlineChats[indexPath.row]
        } else {
            chatModel = offlineChats[indexPath.row]
        }
        if searchController.isActive {
            searchController.dismiss(animated: true, completion: { [weak self] in
                self?.performSegue(withIdentifier: "ToChatView", sender: chatModel)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
        } else {
            self.performSegue(withIdentifier: "ToChatView", sender: chatModel)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

extension ConversationsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            splitChats()
        } else {
            onlineChats = allChats.filter({$0.online ?? false && $0.name?.lowercased().contains(searchText.lowercased()) ?? false})
            offlineChats = allChats.filter({!($0.online ?? false) && $0.name?.lowercased().contains(searchText.lowercased()) ?? false})
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.splitChats()
        self.tableView.reloadData()
    }
}


class MessageManager : CommunicatorDelegate {
    
    static var shared: MessageManager!
    
    init(userName: String) {
        CommunicationManager.shared = CommunicationManager(userName: userName)
        CommunicationManager.shared.delegate = self
    }
    
    weak var listView: ConversationsListViewController?
    weak var chatView: ChatViewController?
    
    func didFoundUser(userID: String, userName: String?) {
        DispatchQueue.main.async {
            if let list = self.listView {
                if let chat = list.allChats.first(where: {$0.userID == userID}) {
                    chat.online = true
                    chat.name = userName
                } else {
                    list.allChats.append(ChatModel(userName, userID: userID, nil, nil, true, false, false))
                }
                list.updateTable()
            }
        }
    }
    
    func didLostUser(userID: String) {
        DispatchQueue.main.async {
            if let list = self.listView {
                if let chat = list.allChats.first(where: {$0.userID == userID}) {
                    chat.online = false
                    if let chatV = self.chatView {
                        if chatV.chatModel?.userID == userID {
                            chatV.disableSendings()
                        }
                    }
                } else {
                    print("We lost user never found")
                }
                list.updateTable()
            }
        }
    }
    
    func stateChanged(displayName: String, state: MCSessionState) {
        DispatchQueue.main.async {
            if let list = self.listView {
                if let chat = list.allChats.first(where: {$0.userID == displayName}) {
                    if state != .connected {
                        chat.online = false
                        if let chatV = self.chatView {
                            if chatV.chatModel?.userID == chat.userID {
                                chatV.disableSendings()
                            }
                        }
                    } else {
                        chat.online = true
                        if let chatV = self.chatView {
                            if chatV.chatModel?.userID == chat.userID {
                                chatV.enableSendings()
                            }
                        }
                    }
                }
                list.updateTable()
            }
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        // Nothing here
    }
    
    func failedToStartAdvertising(error: Error) {
        // Nothing here
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        DispatchQueue.main.async {
            if let list = self.listView {
                if let chat = list.allChats.first(where: {$0.userID == fromUser}) {
                    chat.messages.append(Message(text: text, fromMe: false, date: Date()))
                    chat.lastMessageDate = Date()
                    chat.isLastMessageByMe = false
                    chat.lastMessage = text
                    chat.hasUnreadMessages = true
                    if let chatV = self.chatView {
                        if chatV.chatModel?.userID == fromUser {
                            chat.hasUnreadMessages = false
                            chatV.reloadMessages()
                        }
                    }
                    list.updateTable()
                } else if let chat = list.allChats.first(where: {$0.userID == toUser}) {
                    chat.messages.append(Message(text: text, fromMe: true, date: Date()))
                    chat.lastMessageDate = Date()
                    chat.isLastMessageByMe = true
                    chat.lastMessage = text
                    if let chatV = self.chatView {
                        if chatV.chatModel?.userID == toUser {
                            chatV.reloadMessages()
                        }
                    }
                    list.updateTable()
                } else {
                    print("Received from unknown user")
                }
            }
        }
    }
}

