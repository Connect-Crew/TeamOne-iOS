//
//  BaseModalViewController.swift
//  Core
//
//  Created by 강현준 on 1/23/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

open class BaseModalViewControl : ViewController{
    
    weak var targetView:UIView!
    
    weak var gestureView:UIView!
    
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    var viewHeight:CGFloat = 0
    
    var isCloseClick:Bool = false
    var onCancel:(()->())? = nil
    
    public func setInteractiveDismiss(gestureView:UIView, targetView:UIView, onCancel:(()->())? = nil){
        
        self.onCancel = onCancel
        self.gestureView = gestureView
        self.targetView = targetView
        
        
        let taps = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        self.gestureView.addGestureRecognizer(taps)
        
        
        DispatchQueue.main.async {
            
            self.viewHeight = self.targetView.frame.height
            
        }
    }
    
    @objc func handleSwipeGesture(sender: UIPanGestureRecognizer) {
        
        if sender.translation(in: view).y > 0{
            
            switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.targetView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            case .ended:
                if viewTranslation.y < self.viewHeight * 0.5 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                        self.targetView.transform = .identity
                    })
                } else {
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.targetView.transform = CGAffineTransform(translationX: 0, y: self.viewHeight)
                    }, completion: { (result) in
                        self.dismiss(animated: false, completion: self.onCancel)
                    })
                    
                    
                }
            default:
                break
            }
        }
    }
    
}

extension BaseModalViewControl{
    
    
    public func showModalAnim(targetView:UIView, alphaView:UIView? = nil, alpha:CGFloat = 0.5){
        
        
        targetView.isHidden = true
        alphaView?.isHidden = true
        alphaView?.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            debugPrint("self.targetView.frame.height : \(targetView.frame.height)")
            
            targetView.transform = CGAffineTransform(translationX: 0, y: targetView.frame.height)
            
            targetView.isHidden = false
            alphaView?.isHidden = false
         
         
            UIView.animate(withDuration: 0.5, animations: {
                alphaView?.alpha = alpha
            })
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                targetView.transform = .identity
            })
        }
    }
    
    public func showModalAnimNoBounce(targetView:UIView){
        
        
        targetView.isHidden = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            debugPrint("self.targetView.frame.height : \(targetView.frame.height)")
            
            targetView.transform = CGAffineTransform(translationX: 0, y: targetView.frame.height)
            
            targetView.isHidden = false
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                targetView.transform = .identity
            })
        }
    }
    
    public func hideModalAnim(targetView:UIView){
        
        
        DispatchQueue.main.async {
            
            targetView.transform = .identity
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                targetView.transform = CGAffineTransform(translationX: 0, y: targetView.frame.height)
            })
        }
    }
    
    
    public func closeModalAnim(targetView:UIView, alphaView:UIView? = nil, completion:(() -> Void)? = nil){
        
        if isCloseClick == false{
            isCloseClick = true
            
            DispatchQueue.main.async {
                
                targetView.transform = .identity
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    alphaView?.alpha = 0
                }, completion: { (result) in
                    
                })
                
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    targetView.transform = CGAffineTransform(translationX: 0, y: targetView.frame.height)
                }, completion: { (result) in
                    self.dismiss(animated: false, completion: completion)
                })
            }
            
        }
    }
    
}
