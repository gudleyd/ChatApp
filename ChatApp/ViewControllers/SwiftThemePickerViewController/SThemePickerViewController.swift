//
//  SThemePickerViewController.swift
//  ChatApp
//
//  Created by Иван Лебедев on 05/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

class SThemePickerViewController: UIViewController {

    var closure: ((UIColor) -> Void)!

    var model = ThemeModel()

    var theme1Button = UIButton()
    var theme2Button = UIButton()
    var theme3Button = UIButton()
    var closeButton = UIButton()

    required init(closure: @escaping (UIColor) -> Void) {
        super.init(nibName: nil, bundle: nil)

        self.closure = closure
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func customizeButton(_ button: UIButton) {
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 152/255, green: 251/255, blue: 152/255, alpha: 1)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)

        model.setTheme1(UIColor.white)
        model.setTheme2(UIColor.black)
        model.setTheme3(UIColor.init(red: 205/255, green: 140/255, blue: 205/255, alpha: 1))

        theme1Button.setTitle("Светлая тема", for: .normal)
        theme2Button.setTitle("Темная тема", for: .normal)
        theme3Button.setTitle("Необычная тема", for: .normal)
        closeButton.setTitle("Закрыть", for: .normal)

        customizeButton(theme1Button)
        customizeButton(theme2Button)
        customizeButton(theme3Button)
        customizeButton(closeButton)

        theme1Button.addTarget(self, action: #selector(themePicked), for: .touchUpInside)
        theme2Button.addTarget(self, action: #selector(themePicked), for: .touchUpInside)
        theme3Button.addTarget(self, action: #selector(themePicked), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [theme1Button, theme2Button, theme3Button, closeButton])
        stackView.axis = .vertical
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)

        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true

        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

    }

    @objc func themePicked(_ sender: UIButton) {
        if sender == theme1Button {
            self.view.backgroundColor = model.theme1()
        } else if sender == theme2Button {
            self.view.backgroundColor = model.theme2()
        } else if sender == theme3Button {
            self.view.backgroundColor = model.theme3()
        }
        closure(self.view.backgroundColor ?? UIColor.white)
    }

    @objc func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
