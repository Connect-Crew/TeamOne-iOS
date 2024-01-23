//
//  UIView+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/11.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

public extension UIView {

    func setLayer(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func setDivider(height: CGFloat, color: UIColor) {
        self.backgroundColor = color
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }

    func setDivider(width: CGFloat, color: UIColor) {
        self.backgroundColor = color
        self.snp.makeConstraints {
            $0.width.equalTo(width)
        }
    }

    func setRound(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.clearCorners()

        self.layer.cornerRadius = radius

        var masked:CACornerMask = []

        if corners.contains(.allCorners){
            masked.insert(.layerMinXMinYCorner)
            masked.insert(.layerMaxXMinYCorner)
            masked.insert(.layerMinXMaxYCorner)
            masked.insert(.layerMaxXMaxYCorner)
        }else{

            if corners.contains(.topLeft){
                masked.insert(.layerMinXMinYCorner)
            }

            if corners.contains(.topRight){
                masked.insert(.layerMaxXMinYCorner)
            }

            if corners.contains(.bottomLeft){
                masked.insert(.layerMinXMaxYCorner)
            }

            if corners.contains(.bottomRight){
                masked.insert(.layerMaxXMaxYCorner)
            }
        }

        self.layer.maskedCorners = masked //
    }

    func setRoundCircle() {
        self.layer.cornerRadius = self.frame.height / 2
    }

    func clearCorners(){
        self.layer.maskedCorners.remove([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
}

// MARK: - Shadow
public extension UIView {
    
    func setBaseShadow(radius: CGFloat, backgroundColor: UIColor = .teamOne.white) {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.backgroundColor = backgroundColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = radius
        self.layer.shadowColor = UIColor(r: 158, g: 158, b: 158, a: 1).cgColor
        self.layer.shadowOpacity = 0.2
    }
    
    enum ShadowPosition {
        case top
        case bottom
        case left
        case right
        case allSides
    }
    
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
                shadowPath.append(UIBezierPath(rect: bounds))
            }
        }
        
        layer.shadowPath = shadowPath.cgPath
    
    }
}
