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

    /**
     레이어의 굵기, 색상을 설정
     - Parameters:
        - width: 굵기
        - color: layer의 색상
     */
    func setLayer(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    /**
     뷰 구분선(가로방향)으로 변경합니다.
     - Parameters:
        - height: CGFloat
     */
    func setDivider(height: CGFloat, width: CGFloat = 1, color: UIColor = .teamOne.grayscaleTwo) {
        self.backgroundColor = color
        self.snp.makeConstraints {
            $0.height.equalTo(height)
            $0.width.equalTo(width)
        }
    }

    /**
     뷰 구분선(세로방향)으로 변경합니다.
     - Parameters:
        - width: CGFloat
     */
    func setDivider(width: CGFloat, height: CGFloat = 1, color: UIColor = .teamOne.grayscaleTwo) {
        self.backgroundColor = color
        self.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
    }

    /**
     뷰의 코너의 radius를 설정합니다.
     - Parameters:
        - raidus: CGFloat
     */
    func setRound(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    /**
     선택한 위치의 코너에만 radius를 적용할 수 있는 메서드
     - Parameters:
        - corners: 적용할 코너
        - radius: 적용할 코너의 radius
     */
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

    /**
     뷰를 원형으로 깎는 메서드, 뷰의 크기가 정해진 뒤 호출해야합니다.
     */
    func setRoundCircle() {
        self.layer.cornerRadius = self.frame.height / 2
    }

    /// 뷰의 코너를 없애는 메서드 입니다.
    func clearCorners(){
        self.layer.maskedCorners.remove([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
}
