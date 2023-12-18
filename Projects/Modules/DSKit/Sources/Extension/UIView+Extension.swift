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

    func setBaseShadow(radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    func clearCorners(){
        self.layer.maskedCorners.remove([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
}
