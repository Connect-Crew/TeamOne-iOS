//
//  UIView+Keyboard.swift
//  Core
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxKeyboard

public extension UIView {
    func adjustForKeyboard(disposeBag: DisposeBag) {

        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardFrame in
                guard let strongSelf = self else { return }

                // 화면의 높이
                let screenHeight = UIScreen.main.bounds.height

                // UIView의 하단 위치
                let viewBottom = strongSelf.frame.origin.y + strongSelf.frame.height

                // 키보드의 상단 위치
                let keyboardTop = screenHeight - keyboardFrame

                // UIView가 키보드에 의해 가려지는 경우 계산
                let offset = max(0, viewBottom - keyboardTop)

                // UIView를 위로 이동
                UIView.animate(withDuration: 0.3) {
                    strongSelf.transform = CGAffineTransform(translationX: 0, y: -offset)
                }
            })
            .disposed(by: disposeBag)
    }
}
