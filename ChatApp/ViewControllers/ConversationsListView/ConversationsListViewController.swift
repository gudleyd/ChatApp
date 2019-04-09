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
        return self.fetchedResultsController.sections?[section].name ?? "Нет имени"
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.fetchedResultsController.object(at: indexPath)
        let chatModel = ChatModel(name: data.user?.userName,
                                  userID: data.user?.userID ?? "No id",
                                  hasUnreadMessages: false)
        StorageManager.shared.updateConversationHasUnreadMessages(userID: data.user?.userID ?? "No id",
                                                                  hasUnreadMessages: false)
        self.performSegue(withIdentifier: "ToChatView", sender: chatModel)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {

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
            if let nip = newIndexPath {
                tableView.deleteRows(at: [nip], with: .automatic)
            }
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
