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
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                guard let superview = self.superview else { return }

                // 스크린과 윈도우의 높이를 가져옵니다.
                let screenHeight = UIScreen.main.bounds.height

                // 키보드가 나타나지 않을 때는 아무 조정도 하지 않습니다.
                if keyboardVisibleHeight == 0 {
                    self.transform = .identity
                    return
                }

                // 뷰의 전역 프레임을 계산합니다.
                let globalFrame = self.convert(self.bounds, to: nil)
                let bottomOfView = globalFrame.maxY

                // 키보드 상단까지의 거리를 계산합니다.
                let keyboardTop = screenHeight - keyboardVisibleHeight

                // 뷰의 하단이 키보드 상단보다 아래에 있는 경우, 뷰를 올려 키보드 위에 위치시킵니다.
                if bottomOfView > keyboardTop {
                    let offset = bottomOfView - keyboardTop
                    let transform = CGAffineTransform(translationX: 0, y: -offset)
                    UIView.animate(withDuration: 0.3) {
                        self.transform = transform
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
