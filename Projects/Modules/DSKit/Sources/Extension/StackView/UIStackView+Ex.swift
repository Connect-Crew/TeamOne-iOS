//
//  UIStackView+Ex.swift
//  DSKitTests
//
//  Created by 강현준 on 2023/11/06.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UIStackView {
    /**
     배열에 추가한 순서대로 스택뷰에 arrangedSubView로 사용합니다
     - Parameters: 추가살 순서대로 정렬된 뷰 배열
     */
    func addArrangeSubViews(views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }

    /// 스택뷰에 추가된 모든 자식뷰를 삭제합니다.
    func removeArrangeSubViewAll() {
        self.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
