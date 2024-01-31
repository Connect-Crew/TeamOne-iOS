//
//  Loading.swift
//  Core
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

/// ActivityIndicator관련 클래스입니다.
public class Loading {
    
    static let backgroundColor = UIColor(red: 112/255.0, green: 112/255.0, blue: 112/255.0, alpha: 0.10)
    
    static let fade = 0.1

    public static var shared = Loading()
    
    static var indicator: UIView = {
        var view = UIView()
        
        let screen: CGRect = UIScreen.main.bounds
        
        var side = screen.width / 4
        var x = (screen.width / 2) - (side / 2)
        var y = (screen.height / 2) - (side / 2)
        
        view.frame = CGRect(x: x, y: y, width: side, height: side)
        view.backgroundColor = backgroundColor
        view.tag = 1
        view.alpha = 0.0
        
        if let image = UIImage(named: "chanho", in: Bundle.module, compatibleWith: .none) {
            let imageView = UIImageView(image: image)
            
            imageView.frame = CGRect(x: side/4, y: side/4, width: side/2, height: side/2)
            
            view.addSubview(imageView)
        } else {
            print("UNFINDED Image")
        }
        
        return view
    }()
    
    static var animation: CABasicAnimation = {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = 2.0
        rotateAnimation.repeatCount = Float.infinity
        return rotateAnimation
    }()

    /**
     액티비티 인디케이터 동작을 시작합니다.
     - Parameters:
        - isFullScreen: true로 사용합니다.
        - stopTouch: 인디케이터가 작동하는 동안 터치이벤트를 받지 않습니다.
     */
    public static func start(isFullScreen: Bool = true, stopTouch: Bool = true) {
        DispatchQueue.main.async {
            if let window: UIWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                
                var found: Bool = false
                
                for subViews in window.subviews {
                    if subViews.tag == 1 {
                        found = true
                    }
                }
                
                if !found {
                    
                    if isFullScreen {
                        let screen: CGRect = UIScreen.main.bounds
                        
                        indicator.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
                        
                        for subview in indicator.subviews {
                            let x = (screen.width / 2) - (subview.frame.width / 2)
                            let y = (screen.height / 2) - (subview.frame.height / 2)
                            subview.frame = CGRect(x: x, y: y, width: subview.frame.width, height: subview.frame.height)
                        }
                    } else {
                        let screen: CGRect = UIScreen.main.bounds
                        let side = screen.width / 4
                        let x = (screen.width / 2) - (side / 2)
                        let y = (screen.height / 2) - (side / 2)
                        indicator.frame = CGRect(x: x, y: y, width: side, height: side)
                        
                        for subview in indicator.subviews {
                            subview.frame = CGRect(x: side / 4, y: side / 4, width: side / 2, height: side / 2)
                            
                        }
                    }
                    
                    if(stopTouch) {
                        indicator.isUserInteractionEnabled = true
                    }
                    
                    for subView in indicator.subviews {
                        subView.layer.add(animation, forKey: nil)
                    }
                    
                    window.addSubview(indicator)
                    
                    UIView.animate(withDuration: fade, delay: 0.5, animations: {
                        self.indicator.alpha = 1.0
                    })
                    
                }
                
            }
        }
    }
    
    /// 액티비티 인디케이터의 동작을 정지시킵니다.
    public static func stop() {
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: fade, delay: 1.0, animations: {
                self.indicator.removeFromSuperview()
                for subview in self.indicator.subviews {
                    subview.layer.removeAllAnimations()
                }
            })
        }
    }
}
