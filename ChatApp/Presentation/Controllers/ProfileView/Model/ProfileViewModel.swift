//
//  ProfileViewModel.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

protocol IProfileViewModel {
    func saveUserProfile(profile: Profile, completion: (() -> Void)?)
    
    func createUIImagePickerController(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate),
                                       sourceType: UIImagePickerController.SourceType,
                                       requestHandler: ((Bool, UIViewController?) -> Void)?)
}

class ProfileViewModel: IProfileViewModel {
    
    var storageManager: IStorageManager!
    var photoService: IPhotoService!
    
    init(storageManager: IStorageManager,
         photoService: IPhotoService) {
        self.storageManager = storageManager
        self.photoService = photoService
    }
    
    func saveUserProfile(profile: Profile, completion: (() -> Void)?) {
        self.storageManager.saveUserProfile(profile: profile, completion: completion)
    }
    
    func createUIImagePickerController(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate),
                                       sourceType: UIImagePickerController.SourceType,
                                       requestHandler: ((Bool, UIViewController?) -> Void)?) {
         self.photoService.createUIImagePickerController(delegate: delegate, sourceType: sourceType, requestHandler: requestHandler)
    }
}
