//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 21/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import CoreData
import MultipeerConnectivity

class ConversationsListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)

    var allChats: [ChatModel] = []
    var onlineChats: [ChatModel] = []
    var offlineChats: [ChatModel] = []

    var dataProvider = DataProvider()

    var appUser: Profile?

    enum Sections: Int {
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

        //self.navigationItem.searchController = searchController
//        self.navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
//
//        searchController.searchBar.delegate!.searchBar?(searchController.searchBar, textDidChange: "")

        self.appUser = StorageManager.shared.getUserProfile()
        CommunicationManager.shared = CommunicationManager(userName: appUser?.name ?? "No name")
        CommunicationManager.shared.delegate = dataProvider
        dataProvider.listVC = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.updateTable()
    }

    lazy var fetchedResultsController: NSFetchedResultsController<CDConversation> = {
        let frc = self.dataProvider.conversationsListFRC()
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let err {
            print("Cant fetch in ConversationListVC")
            print(err)
        }
        return frc
    }()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToChatView" {
            let chatModel = sender as? ChatModel
            let obj = segue.destination as? ChatViewController
            obj?.title = (chatModel?.name ?? "Unknown")
            obj?.chatModel = chatModel
            dataProvider.chatVC = obj
            obj?.dataProvider = self.dataProvider
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    @IBAction func themePickerOpenButtonClicked(_ sender: Any) {
        let sThemePickerViewController = SThemePickerViewController(closure: { [weak self] theme in
            self?.setTheme(theme)
        })
        self.present(sThemePickerViewController, animated: true, completion: nil)
    }

    func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ConversationsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fetchedResultsController.sections![section].name
    }
}

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
                       online: data.user?.isOnline ?? false,
                       hasUnreadMessages: data.hasUnreadMessages)
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //let dialogName = searchedConversations[indexPath.row].name!
//        let vc = ConversationViewController(conversationListDataProvider: self.viewModel, conversationId: self.fetchedResultsController.object(at: indexPath).conversationId!)
//        vc.dialogTitle = (self.fetchedResultsController.object(at: indexPath).participants?.allObjects.first as! User).name
//        //vc.connectedUserID = self.viewModel.getUserIdBy(username: dialogName)
//        vc.connectedUserID = (self.fetchedResultsController.object(at: indexPath).participants?.allObjects.first! as! User).userId!
//        vc.conversation = self.fetchedResultsController.object(at: indexPath)
//        self.performSegue(withIdentifier: "ToChatView", sender: chatModel)
//        self.tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == Sections.online.rawValue && onlineChats.count > 0 {
//            return onlineChats.count
//        } else {
//            return offlineChats.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as? ChatTableViewCell else {
//            print("No cell?")
//            return UITableViewCell()
//        }
//        if indexPath.section == Sections.online.rawValue && onlineChats.count > 0 {
//            cell.configure(from: onlineChats[indexPath.row])
//        } else {
//            cell.configure(from: offlineChats[indexPath.row])
//        }
//        return cell
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.fetchedResultsController.object(at: indexPath)
        let chatModel = ChatModel(data.user?.userName,
                                  userID: (data.user?.userID)!,
                                  data.lastMessage,
                                  data.lastMessageDate,
                                  data.user?.isOnline,
                                  data.hasUnreadMessages,
                                  data.isLastMessageByMe)
        StorageManager.shared.updateConversationHasUnreadMessages(userID: data.user?.userID ?? "No id", hasUnreadMessages: false)
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
            //splitChats()
        } else {
            onlineChats = allChats.filter({$0.online ?? false && $0.name?.lowercased().contains(searchText.lowercased()) ?? false})
            offlineChats = allChats.filter({!($0.online ?? false) && $0.name?.lowercased().contains(searchText.lowercased()) ?? false})
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //self.splitChats()
        self.tableView.reloadData()
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        tableView.reloadSectionIndexTitles()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //self.tableView.reloadSectionIndexTitles()
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
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
    }
}
