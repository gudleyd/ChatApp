//
//  ProfileView+IPBPictureHasChosenDelegate.swift
//  ChatApp
//
//  Created by Иван Лебедев on 16/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

extension ProfileViewController: IPBPictureHasChosenDelegate {
    
    func PBPictureHasChosen(pbimage: PBImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.sync {
                self.showActivityIndicator()
                self.saveButton.isEnabled = false
            }
            if let url = URL(string: pbimage.largeImageURL),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                DispatchQueue.main.sync {
                    self.profile.avatar = image
                    self.profileImageView.image = image
                    self.isNeedToEnableButtons()
                }
            }
            DispatchQueue.main.sync {
                self.dismissActivityIndicator()
                self.saveButton.isEnabled = true
            }
        }
    }
}
