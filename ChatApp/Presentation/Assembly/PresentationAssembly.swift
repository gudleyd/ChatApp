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
    
    func getInternetGalleryViewController() -> InternetGalleryViewController
    
    var serviceAssembly: IServiceAssembly { get }
}

class PresentationAssembly: IPresentationAssembly {
    
    var serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
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
                           model: ProfileViewModel(storageService: self.serviceAssembly.storageService,
                                                   photoService: self.serviceAssembly.photoService))
        return vc
    }
    
    func getConversationsListViewController() -> ConversationsListViewController {
        guard let vc = UIStoryboard(name: "ConversationsListViewController",
                                    bundle: nil)
            .instantiateViewController(withIdentifier: "ConversationsListViewController") as? ConversationsListViewController else {
            fatalError("Can't instantiate ConversationsListViewController from storyboard")
        }
        let dataProvider = DataProvider(storageManager: self.serviceAssembly.storageService)
        vc.setDependencies(assembly: self,
                           dataProvider: dataProvider,
                           model: ConversationsListModel(storageService: self.serviceAssembly.storageService))
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
                           model: ConversationViewModel(communicator: self.serviceAssembly.communicatorService,
                                                        storageManager: self.serviceAssembly.storageService))
        return vc
    }
    
    func getInternetGalleryViewController() -> InternetGalleryViewController {
        guard let vc = UIStoryboard(name: "InternetGallery",
                                    bundle: nil)
            .instantiateViewController(withIdentifier: "InternetGalleryViewController") as? InternetGalleryViewController else {
            fatalError("Can't instantiate InternetGalleryViewController from storyboard")
        }
        vc.setDependencies(model: InternetGalleryModel(networkService: self.serviceAssembly.networkService))
        return vc
    }
    
    func setCommunicatorDelegate(toSet: CommunicatorDelegate) {
        self.serviceAssembly.communicatorService.communicator.delegate = toSet
    }
}
