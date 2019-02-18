//
//  ViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 07/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var chooseProfileImageButton: UIButton!
    
    let defaultProfileImage = UIImage(named: "placeholder-user")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //print(editButton.frame)
        /*
            Unexpectedly found nil while unwrapping an Optional value
            Это произошло, потому что переменные прикрепляются к своим вью, заданным на сторибордах,
            в функции loadView, а не в init'е
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Debugger.shared.Print("editButton frame in viewDidLoad: \(editButton.frame)")
        
        setupUI()
        profileImageView.openBlind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Debugger.shared.Print("editButton frame in viewDidAppear: \(editButton.frame)")
        /*
            Потому что во viewDidLoad мы загрузили view со storyboard'а, а там у нас iPhone SE, а
            autolayout к тому моменту еще не произошел
         */
    }
    
    
    func setupUI() {
        chooseProfileImageButton.setImage(UIImage(named: "photo-camera-icon"), for: .normal)
        chooseProfileImageButton.layer.cornerRadius = 16
        chooseProfileImageButton.layer.borderWidth = 1
        chooseProfileImageButton.layer.borderColor = UIColor.white.cgColor
        
        editButton.layer.cornerRadius = 8
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 1
        
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
        profileImageView.image = defaultProfileImage
        
        nameLabel.text = "Иван Лебедев"
        
        statusLabel.text = "люблю спортивное программирование🔥🔥 и все что с ним связано😜😜 алгоритмы сортировки 💕💕😎👌графы😍😍😲 рекурсия 😈😈 📈😆🤘дискретная математика💗💗"
    }
    
    func createUIImagePickerController(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate),
                                       sourceType: UIImagePickerController.SourceType,
                                       allowEditing: Bool = true)
        -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = allowEditing
        return imagePicker
    }
    
    func deleteProfileImage() {
        profileImageView.closeBlind(completionHandler: {
            self.profileImageView.image = self.defaultProfileImage
            self.profileImageView.openBlind()
        })
    }
    
    func openCamera()
    {
        /* Проверяем наличие камеры на устройстве */
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) else {
            let noCameraAlert = UIAlertController(title: "Внимание", message: "На вашем устройстве отсутствует камера", preferredStyle: .alert)
            noCameraAlert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(noCameraAlert, animated: true, completion: nil)
            return
        }
        
        /*
            Проверяем есть ли доступ к камере, чтобы в случае его отсутствия показать alert,
            а не открывать пустой интерфейс камеры.
        */
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        self.openCamera()
                    }
                }
            } else {
                let noCameraAccessAlert = UIAlertController(title: "Внимание",
                                              message: "Нет доступа к камере. Измените доступ в настройках.",
                                              preferredStyle: .alert)
                noCameraAccessAlert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                self.present(noCameraAccessAlert, animated: true, completion: nil)
            }
            return
        }
        
        profileImageView.closeBlind()
        self.present(self.createUIImagePickerController(delegate: self, sourceType: .camera),
                     animated: true, completion: nil)
    }
    
    func openGallery() {
        
        /* Проверяем доступ к медиатеке */
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) else {
            let noGalleryAccessAlert  = UIAlertController(title: "Внимание",
                                                          message: "Нет доступа к медиатеке.",
                                                          preferredStyle: .alert)
            noGalleryAccessAlert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(noGalleryAccessAlert, animated: true, completion: nil)
            return
        }
        
        profileImageView.closeBlind()
        self.present(self.createUIImagePickerController(delegate: self, sourceType: .photoLibrary),
                     animated: true, completion: nil)
    }
    
    @IBAction func chooseProfileImageButtonTapped(_ sender: Any) {
        Debugger.shared.Print("Выберите изображение профиля")
        
        let imageAlert = UIAlertController(title: "Выбрать фотографию", message: nil, preferredStyle: .actionSheet)
        imageAlert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        imageAlert.addAction(UIAlertAction(title: "Медиатека", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        let deleteProfileImageAction = UIAlertAction(title: "Удалить фотографию", style: .default, handler: { _ in
            self.deleteProfileImage()
        })
        deleteProfileImageAction.isEnabled = (profileImageView.image != defaultProfileImage)
        deleteProfileImageAction.setValue(UIColor.red, forKey: "titleTextColor")
        imageAlert.addAction(deleteProfileImageAction)
        
        imageAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        self.present(imageAlert, animated: true, completion: nil)
    }
    
}
