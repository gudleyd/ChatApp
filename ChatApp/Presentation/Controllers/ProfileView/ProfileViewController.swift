//
//  ViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 07/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import AVFoundation

protocol IPBPictureHasChosenDelegate: class {
    
    func PBPictureHasChosen(pbimage: PBImage)
    
}

class ProfileViewController: UIViewController, UITextViewDelegate {
    
    var assembly: IPresentationAssembly!
    var model: IProfileViewModel!
    
    func setDependencies(assembly: IPresentationAssembly,
                         model: IProfileViewModel) {
        self.assembly = assembly
        self.model = model
    }

    @IBOutlet weak var profileImageView: BlindImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var statusTextField: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var chooseProfileImageButton: UIButton!
    @IBOutlet var dismissEditing: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    var profile: Profile = Profile()
    var lastSavedProfile: Profile = Profile()

    let defaultProfileImage = UIImage(named: "placeholder-user")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        Debugger.shared.dbprint("editButton frame in viewDidLoad: \(editButton.frame)")

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        profile = self.assembly.serviceAssembly.storageService.getUserProfile()
        lastSavedProfile = profile.copy()

        setupUI()
        disableEditing()
        profileImageView.openBlind()

        editButton.addTarget(self, action: #selector(enableEditing), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(profileSave), for: .touchUpInside)
        dismissEditing.addTarget(self, action: #selector(disableEditing), for: .touchUpInside)
        statusTextField.delegate = self as UITextViewDelegate

        nameTextField.addTarget(self, action: #selector(nameChanged(_:)), for: .allEditingEvents)

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Debugger.shared.dbprint("editButton frame in viewDidAppear: \(editButton.frame)")
        /*
            Потому что во viewDidLoad мы загрузили view со storyboard'а, а там у нас iPhone SE, а
            autolayout к тому моменту еще не произошел
         */
    }

    func styleButton(_ button: UIButton!) {
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
    }

    func setupUI() {
        chooseProfileImageButton.setImage(UIImage(named: "photo-camera-icon"), for: .normal)
        chooseProfileImageButton.layer.cornerRadius = 16
        chooseProfileImageButton.layer.borderWidth = 1
        chooseProfileImageButton.layer.borderColor = UIColor.white.cgColor

        styleButton(editButton)
        styleButton(saveButton)

        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.masksToBounds = true
        profileImageView.image = profile.avatar

        nameTextField.layer.masksToBounds = true

        statusTextField.layer.masksToBounds = true

        setProfile()
    }

    func setProfile() {
        nameTextField.text = profile.name
        statusTextField.text = profile.status
        profileImageView.image = profile.avatar
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        profileImageView.closeBlind(completionHandler: { [weak self] in
            self?.profileImageView.image = self?.defaultProfileImage
            self?.profile.avatar = self?.profileImageView.image ?? UIImage(named: "placeholder-user") ?? UIImage()
            DispatchQueue.main.async {
                self?.profileImageView.openBlind()
                self?.isNeedToEnableButtons()
            }
        })
    }

    @objc func profileSave() {
        self.model.saveUserProfile(profile: profile, completion: {
            let alert = UIAlertController(title: "Сохранено", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in}))
            self.lastSavedProfile = self.profile.copy()
            self.disableEditing()
            self.present(alert, animated: true, completion: nil)
        })
    }

    @objc func enableEditing() {
        nameTextField.isUserInteractionEnabled = true
        statusTextField.isEditable = true
        dismissEditing.isHidden = false

        editButton.isHidden = true
        saveButton.isHidden = false
        
        saveButton.isEnabled = false

        statusTextField.layer.cornerRadius = 16
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.black.cgColor

        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.black.cgColor

        chooseProfileImageButton.isHidden = false

        closeButton.isHidden = true
    }

    @objc func disableEditing() {
        nameTextField.isUserInteractionEnabled = false
        statusTextField.isEditable = false
        dismissEditing.isHidden = true

        editButton.isHidden = false
        saveButton.isHidden = true
        
        statusTextField.layer.borderWidth = 0
        nameTextField.layer.borderWidth = 0

        chooseProfileImageButton.isHidden = true

        profile = lastSavedProfile.copy()
        setProfile()

        closeButton.isHidden = false
    }

    func isNeedToEnableButtons() {
        if profile.name != lastSavedProfile.name || profile.status != lastSavedProfile.status || profile.avatar != lastSavedProfile.avatar {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        self.profile.status = statusTextField.text
        isNeedToEnableButtons()
    }

    @objc func nameChanged(_ sender: UITextField) {
        self.profile.name = nameTextField.text
        isNeedToEnableButtons()
    }

    func openCamera() {
        self.model.createUIImagePickerController(delegate: self, sourceType: .camera, requestHandler: { (status, vc) in
            if vc == nil {
                self.openCamera()
                return
            } else if status {
                self.profileImageView.closeBlind()
            }
            if let goodVC = vc {
                self.present(goodVC, animated: true, completion: nil)
            }
        })
    }

    func openGallery() {
        self.model.createUIImagePickerController(delegate: self, sourceType: .photoLibrary, requestHandler: { (status, vc) in
            if vc == nil {
                self.openGallery()
                return
            } else if status {
                self.profileImageView.closeBlind()
            }
            if let goodVC = vc {
                self.present(goodVC, animated: true, completion: nil)
            }
        })
    }
    
    func openInternetGallery() {
        let vc = self.assembly.getInternetGalleryViewController()
        vc.model.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func chooseProfileImageButtonTapped(_ sender: Any) {
        Debugger.shared.dbprint("Выберите изображение профиля")

        let imageAlert = UIAlertController(title: "Выбрать фотографию", message: nil, preferredStyle: .actionSheet)
        imageAlert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.openCamera()
        }))

        imageAlert.addAction(UIAlertAction(title: "Медиатека", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        imageAlert.addAction(UIAlertAction(title: "Загрузить", style: .default, handler: { _ in
            self.openInternetGallery()
        }))

        let deleteProfileImageAction = UIAlertAction(title: "Удалить фотографию", style: .default, handler: { [weak self] _ in
            self?.deleteProfileImage()
        })
        deleteProfileImageAction.isEnabled = (profileImageView.image != defaultProfileImage)
        deleteProfileImageAction.setValue(UIColor.red, forKey: "titleTextColor")
        imageAlert.addAction(deleteProfileImageAction)

        imageAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

        self.present(imageAlert, animated: true, completion: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    @objc func hideKeyboard() {
        nameTextField.endEditing(true)
        statusTextField.endEditing(true)
    }

}

extension ProfileViewController {
    func showActivityIndicator() {
        self.activityIndicator.layer.masksToBounds = true
        self.activityIndicator.layer.cornerRadius = 8
        self.activityIndicator.backgroundColor = UIColor.lightGray
        self.activityIndicator.center = self.view.center
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
    }
    
    func dismissActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
}
