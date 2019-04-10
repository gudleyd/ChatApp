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

    @IBOutlet internal var tableView: UITableView!
    
    var assembly: IPresentationAssembly!
    var dataProvider: IDataProvider!
    var model: IConversationsListModel!
    
    func setDependencies(assembly: IPresentationAssembly,
                         dataProvider: IDataProvider,
                         model: IConversationsListModel) {
        self.assembly = assembly
        self.dataProvider = dataProvider
        self.model = model
    }

    @IBAction func openProfile(_ sender: Any) {
        let vc = self.assembly.getProfileViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    var appUser: Profile?

    enum Sections: Int {
        case online = 0
        case offline = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataProvider.listVC = self
        
        self.assembly.setCommunicatorDelegate(toSet: dataProvider)

        self.setTheme(UserDefaults.loadTheme())

        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = 80

        let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatTableViewCell")
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

    @IBAction func themePickerOpenButtonClicked(_ sender: Any) {
        let sThemePickerViewController = self.assembly.getSThemePickerViewController(closure: { [weak self] theme in
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
