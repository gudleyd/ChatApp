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
    weak var dataProvider: IDataProvider?
    var assembly: IPresentationAssembly!
    var model: IConversationViewModel!
    
    var customNavBarLabel: UILabel!
    
    func setDependencies(assembly: IPresentationAssembly,
                         model: IConversationViewModel) {
        self.assembly = assembly
        self.model = model
    }

    @IBOutlet internal weak var tableView: UITableView!
    
    var accessoryView: MessageInputAccessoryView!

    var fetchedResultsController: NSFetchedResultsController<CDMessage>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let accessory = UINib(nibName: "MessageInputAccessory",
                                    bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as? MessageInputAccessoryView else {
                fatalError()
        }
        accessoryView = accessory
        
        self.title = chatModel?.name ?? "Unknown"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.customNavBarLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        self.customNavBarLabel.text = self.title
        self.customNavBarLabel.textColor = UIColor.black
        self.customNavBarLabel.font = UIFont(name: "Helvetica-Bold", size: 20.0)
        self.customNavBarLabel.backgroundColor = UIColor.clear
        self.customNavBarLabel.adjustsFontSizeToFitWidth = true
        self.customNavBarLabel.textAlignment = .center
        self.navigationItem.titleView = self.customNavBarLabel
        
        self.dataProvider?.chatVC = self

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
        self.accessoryView.delegate = self

        self.accessoryView.sendButton.isEnabled = self.model.connectWithUser(userID: chatModel?.userID ?? "")

        setupObservers()
    }

    func enableSendings() {
        DispatchQueue.main.async {
            UIView.animateKeyframes(withDuration: 1,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        self.customNavBarLabel.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
                                        self.customNavBarLabel.textColor = UIColor.green
            }, completion: nil)
            self.accessoryView.animate(isOn: true)
            self.accessoryView.sendButton.isEnabled = true
        }
    }

    func disableSendings() {
        DispatchQueue.main.async {
            UIView.animateKeyframes(withDuration: 1,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        self.customNavBarLabel.transform = .identity
                                        self.customNavBarLabel.textColor = UIColor.black
            }, completion: nil)
            self.accessoryView.animate(isOn: false)
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
        self.model.updateConversationHasUnreadMessages(
            userID: chatModel?.userID ?? "No id", hasUnreadMessages: false
        )

        self.model.disconnectPeers()
        removeObservers()
    }

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
