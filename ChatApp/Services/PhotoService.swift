//
//  PhotoService.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

protocol IPhotoService {
    func createUIImagePickerController(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate),
                                       sourceType: UIImagePickerController.SourceType,
                                       requestHandler: ((Bool, UIViewController?) -> Void)?)
}

class PhotoService: IPhotoService {
    
    func createUIImagePickerController(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate),
                                       sourceType: UIImagePickerController.SourceType,
                                       requestHandler: ((Bool, UIViewController?) -> Void)?) {
        if sourceType == .camera {
            guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) else {
                let noCameraAlert = UIAlertController(title: "Внимание", message: "На вашем устройстве отсутствует камера", preferredStyle: .alert)
                noCameraAlert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                requestHandler?(false, noCameraAlert)
                return
            }
            
            /*
             Проверяем есть ли доступ к камере, чтобы в случае его отсутствия показать alert,
             а не открывать пустой интерфейс камеры.
             */
            guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
                if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { success in
                        requestHandler?(success, nil)
                    }
                } else {
                    let noCameraAccessAlert = UIAlertController(title: "Внимание",
                                                                message: "Нет доступа к камере. Измените доступ в настройках.",
                                                                preferredStyle: .alert)
                    noCameraAccessAlert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    requestHandler?(false, noCameraAccessAlert)
                }
                return
            }
        } else if sourceType == .photoLibrary {
            /* Проверяем доступ к медиатеке */
            guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) else {
                let noGalleryAccessAlert  = UIAlertController(title: "Внимание",
                                                              message: "Нет доступа к медиатеке.",
                                                              preferredStyle: .alert)
                noGalleryAccessAlert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                requestHandler?(false, noGalleryAccessAlert)
                return
            }
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        requestHandler?(true, imagePicker)
    }
}
