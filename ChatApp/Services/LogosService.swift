//
//  LogosService.swift
//  ChatApp
//
//  Created by Иван Лебедев on 22/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import UIKit

protocol ILogosService {
    func draw(location: CGPoint)
}

class LogosService: NSObject, ILogosService, UIGestureRecognizerDelegate {
    
    var window: UIWindow!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    init(window: UIWindow) {
        super.init()
        
        self.window = window
        
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapped(gesture:)))
        self.longPressGestureRecognizer.cancelsTouchesInView = false
        self.longPressGestureRecognizer.minimumPressDuration = 1.0
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
        self.tapGestureRecognizer.cancelsTouchesInView = false
        self.tapGestureRecognizer.delegate = self
        
        self.window.addGestureRecognizer(self.tapGestureRecognizer)
        self.window.addGestureRecognizer(self.longPressGestureRecognizer)
    }
    
    override init() {
        super.init()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.draw(location: touch.location(in: self.window))
        return true
    }
    
    @objc func tapped(gesture: UIGestureRecognizer) {
        let location = gesture.location(in: self.window)
        
        self.draw(location: location)
    }
    
    func draw(location: CGPoint) {
        let size: CGFloat = CGFloat.random(in: 15 ... 25)
        
        let imageView = UIImageView(image: UIImage(named: "tinkoff-logo"))
        
        let startX = location.x + CGFloat.random(in: -5 ... 5)
        let startY = location.y + CGFloat.random(in: -5 ... 5)
        imageView.frame = CGRect(origin: CGPoint(x: startX, y: startY),
                                 size: CGSize(width: size, height: size))
        let toPoint = CGPoint(x: location.x + CGFloat.random(in: -100 ... 100),
                              y: location.y + CGFloat.random(in: -100 ... 100))
        
        let move: CGFloat = CGFloat.random(in: 30 ... 70)
        
        let p1 = CGPoint(x: location.x - move, y: (location.y + toPoint.y) / 2)
        let p2 = CGPoint(x: location.x + move, y: p1.y)
        self.window.addSubview(imageView)
        let path = UIBezierPath()
        path.move(to: location)
        path.addCurve(to: toPoint, controlPoint1: p1, controlPoint2: p2)
        
        let duration: CGFloat = 2
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            UIView.transition(with: imageView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }, completion: { (_) in
                imageView.removeFromSuperview()
            })
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = CFTimeInterval(duration)
        animation.path = path.cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        imageView.layer.add(animation, forKey: "movingAnimation")
        
        CATransaction.commit()
    }
}
