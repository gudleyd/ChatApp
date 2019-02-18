//
//  ProfileViewController-ImagePickerControllerDelegate.swift
//  ChatApp
//
//  Created by Иван Лебедев on 17/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

extension ProfileViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.profileImageView.image = chosenImage
        dismiss(animated: true, completion: { self.profileImageView.openBlind() })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: { self.profileImageView.openBlind() })
    }
}
