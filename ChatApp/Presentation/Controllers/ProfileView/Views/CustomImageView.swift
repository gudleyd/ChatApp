//
//  CustomImageView.swift
//  ChatApp
//
//  Created by Иван Лебедев on 17/02/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

class BlindImageView: UIImageView {

    var blindView = UIVisualEffectView()

    func setupUI() {
        blindView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.extraLight))
        blindView.frame = self.bounds
        self.addSubview(blindView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setupUI()
    }

    func closeBlind(completionHandler : @escaping () -> Void = {}) {
        blindView.frame = self.bounds
        blindView.center.y -= self.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.blindView.center.y += self.frame.height
        }, completion: { _ in
            completionHandler()
        })
    }

    func openBlind(completionHandler : @escaping () -> Void = {}) {
        blindView.frame = self.bounds
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.blindView.center.y -= self.frame.height
        }, completion: { _ in
            completionHandler()
        })
    }
    
}
