//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

protocol IPresentationAssembly {
    func getSThemePickerViewController(closure: @escaping ((UIColor) -> Void)) -> SThemePickerViewController
    
    func getProfileViewController() -> ProfileViewController
    
    func getConversationsListViewController() -> ConversationsListViewController
    
    func getConversationViewController(with: ChatModel) -> ConversationViewController
    
    func setCommunicatorDelegate(toSet: CommunicatorDelegate)
    
    var serviceAssembly: IServiceAssembly { get }
    var coreAssembly: ICoreAssembly { get }
}

class PresentationAssembly: IPresentationAssembly {
    
    var coreAssembly: ICoreAssembly
    var serviceAssembly: IServiceAssembly
    
    init(coreAssembly: ICoreAssembly, serviceAssembly: IServiceAssembly) {
        self.coreAssembly = coreAssembly
        self.serviceAssembly = serviceAssembly
    }
    
    func getSThemePickerViewController(closure: @escaping ((UIColor) -> Void)) -> SThemePickerViewController {
        let vc = SThemePickerViewController(closure: closure)
        return vc
    }
    
    func getProfileViewController() -> ProfileViewController {
        guard let vc = UIStoryboard(name: "ProfileView", bundle: nil)
            .instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            fatalError("Can't instantiate ProfileViewController from storyboard")
        }
        vc.setDependencies(assembly: self,
                           model: ProfileViewModel(storageManager: self.serviceAssembly.storageManager,
                                                   photoService: self.serviceAssembly.photoService))
        return vc
    }
    
    func getConversationsListViewController() -> ConversationsListViewController {
        guard let vc = UIStoryboard(name: "ConversationsListViewController",
                                    bundle: nil)
            .instantiateViewController(withIdentifier: "ConversationsListViewController") as? ConversationsListViewController else {
            fatalError("Can't instantiate ConversationsListViewController from storyboard")
        }
        let dataProvider = DataProvider(storageManager: self.serviceAssembly.storageManager)
        vc.setDependencies(assembly: self,
                           dataProvider: dataProvider,
                           model: ConversationsListModel(storageManager: self.serviceAssembly.storageManager))
        return vc
    }
    
    func getConversationViewController(with: ChatModel) -> ConversationViewController {
        guard let vc = UIStoryboard(name: "ChatView",
                                    bundle: nil)
            .instantiateViewController(withIdentifier: "ChatView") as? ConversationViewController else {
            fatalError("Can't instantiate ConversationViewController from storyboard")
        }
        vc.chatModel = with
        vc.setDependencies(assembly: self,
                           model: ConversationViewModel(communicator: self.coreAssembly.communicator,
                                                        storageManager: self.serviceAssembly.storageManager))
        return vc
    }
    
    func setCommunicatorDelegate(toSet: CommunicatorDelegate) {
        self.coreAssembly.communicator.delegate = toSet
    }
}
