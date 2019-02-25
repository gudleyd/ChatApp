//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 21/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

var exampleChats : [ChatModel] = [
    ChatModel("Олег Емельянов", "Ок", Date(timeIntervalSince1970: 1551087725 - 60000), true, false, true),
    ChatModel("Арнольд Баранов", "Да", Date(timeIntervalSince1970: 1551087725 - 90000), true, true, true),
    ChatModel("Дмитрий Мамонтов", "Лол", Date(timeIntervalSince1970: 1551087725 - 100000), true, false, false),
    ChatModel("Жанна Рожкова", "Ты опять меня игноришь?", Date(), true, true, false),
    ChatModel("Лариса Ефимова", ":)", Date(timeIntervalSince1970: 454325653), true, false, false),
    ChatModel("Илон Маск", "Как тебе такое?", Date(), true, true, true),
    ChatModel("Донат Коновалов", "Давай не будем о политике", Date(timeIntervalSince1970: 1551087725 - 3456000), true, false, false),
    ChatModel("Адольф Сысоев", "Антихайп!", Date(), true, false, true),
    ChatModel("Оскар Богданов", "How do you do?", Date(), true, false, false),
    ChatModel("Харитон Носов", "Чего ты ждешь?", Date(), true, true, true),
    ChatModel("Варвара Кириллова", "я так не думаю", Date(), false, true, false),
    ChatModel("Евдоким Гриднев", "Ок, я жду", Date(), false, false, false),
    ChatModel("Удаленный Аккаунт", "Привет, ну ты зажигаешь! Смотри видео с собой по ссылке. $удаленная ссылка$", Date(), false, true, false),
    ChatModel("Арсений Герасимов", "Согласен", Date(), false, false, true),
    ChatModel("Моисей Самсонов", "Напиши, когда соберешься отдавать", Date(timeIntervalSince1970: 0), false, false, true),
    ChatModel("Макс Данилов", "Ок, я жду", Date(timeIntervalSince1970: 1551080000), false, true, false),
    ChatModel("Виктор Кудряшов", "Верните мне мой 2007!", Date(timeIntervalSince1970: 3456345634), false, false, false),
    ChatModel("Борислав Быков", "пока", Date(timeIntervalSince1970: 423589023), false, false, false),
    ChatModel("Кирилл Шувалов", "Привет проверяющим", Date(timeIntervalSince1970: 32425234), false, false, true),
    ChatModel("Христофор Павлов", "Тест", Date(timeIntervalSince1970: 34563583245), false, false, false)
]

import UIKit

class ConversationsListViewController : UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var allChats: [ChatModel] = exampleChats
    var onlineChats: [ChatModel] = []
    var offlineChats: [ChatModel] = []
    
    enum Sections : Int {
        case online = 0
        case offline = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    func splitChats() {
        onlineChats = allChats.filter({$0.online ?? false})
        offlineChats = allChats.filter({!($0.online ?? false)})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToChatView" {
            let chatModel = sender as? ChatModel
            let obj = segue.destination as! ChatViewController
            obj.title = (chatModel?.name ?? "Unknown")
        } else {
            super.prepare(for: segue, sender: sender)
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
            searchController.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "ToChatView", sender: chatModel)
                self.tableView.deselectRow(at: indexPath, animated: true)
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
        splitChats()
        tableView.reloadData()
    }
    
}
