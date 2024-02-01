//
//  UIView+Shadow.swift
//  DSKit
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

// MARK: - Shadow
public extension UIView {
    
    /**
     전체 그림자를 설정할 수 있는 메서드
     - Parameters:
        - offsetX, Y : offsetX, offsetY
        - color: 그림자의 색(alpha: 1)
        - opacity: 연한 정도(실제 그림자의 alpha)
        - blurRadius: 그림자의 corner radius
        - backgroundColor: 뷰의 백그라운드 컬러
     - returns: Void
     */
    func setBaseShadow(
        offsetX: Int = 0,
        offsetY: Int = 0,
        color: UIColor = .init(r: 158, g: 158, b: 158, a: 1),
        opacity: Float = 0.2,
        radius: CGFloat,
        backgroundColor: UIColor = .teamOne.white)
    {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        self.backgroundColor = backgroundColor
        self.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
    }
    
    enum ShadowPosition {
        case top
        case bottom
        case left
        case right
        case allSides
    }
    
    /**
     좌, 우, 상, 하 의 그림자를 설정할 수 있는 메서드
     - Parameters:
        - offsetX, Y : offsetX, offsetY
        - blurRadius: 그림자의 corner radius
        - color: 그림자의 색(alpha: 1)
        - opacity: 연한 정도(실제 그림자의 alpha)
        - position: 설정할 그림자들의 포지션
     - returns: Void
     */
    func applyShadow(
        offsetX: CGFloat, offsetY: CGFloat,
        blurRadius: CGFloat, color: UIColor,
        opacity: Float, positions: [ShadowPosition])
    {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowRadius = blurRadius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        
        let shadowPath = UIBezierPath()
        let shadowHeight: CGFloat = offsetY
        let shadowWidth: CGFloat = offsetX
        
        for position in positions {
            switch position {
            case .top:
                shadowPath.move(to: CGPoint(x: 0, y: 0))
                shadowPath.addLine(to: CGPoint(x: bounds.maxX, y: 0))
                shadowPath.addLine(to: CGPoint(x: bounds.maxX, y: -shadowHeight))
                shadowPath.addLine(to: CGPoint(x: 0, y: -shadowHeight))
            case .bottom:
                shadowPath.move(to: CGPoint(x: 0, y: bounds.maxY))
                shadowPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                shadowPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY + shadowHeight))
                shadowPath.addLine(to: CGPoint(x: 0, y: bounds.maxY + shadowHeight))
            case .left:
                shadowPath.move(to: CGPoint(x: 0, y: 0))
                shadowPath.addLine(to: CGPoint(x: 0, y: bounds.maxY))
                shadowPath.addLine(to: CGPoint(x: -shadowWidth, y: bounds.maxY))
                shadowPath.addLine(to: CGPoint(x: -shadowWidth, y: 0))
            case .right:
                shadowPath.move(to: CGPoint(x: bounds.maxX, y: 0))
                shadowPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                shadowPath.addLine(to: CGPoint(x: bounds.maxX + shadowWidth, y: bounds.maxY))
                shadowPath.addLine(to: CGPoint(x: bounds.maxX + shadowWidth, y: 0))
            case .allSides:
                clipsToBounds = false
                layer.masksToBounds = false
                
                backgroundColor = .white
                layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
                layer.shadowRadius = blurRadius
                layer.shadowColor = color.cgColor
                layer.shadowOpacity = opacity
                
                return
            }
        }
        
        layer.shadowPath = shadowPath.cgPath
    
    }
}
