//
//  UIViewController+ErrorAlert.swift
//  DSKit
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Core
import SnapKit
import Then

public extension Reactive where Base: UIViewController {
    /// Error를 띄웁니다.
    /// Using: ViewController().rx.presentErrorAlert
    var presentErrorAlert: Binder<Error> {
        return Binder(self.base) { base, error in
            base.presentErrorAlert(
                error: error, finishSubject: nil
            )
        }
    }
}

public extension UIViewController {
    
    /**
     에러 알럿을 띄웁니다.
     - Parameters:
        - error: Error Type
        - finishSubject: 에러가 사라지고 어떤 작업을 해야할 경우 사용합니다. 사용자가 확인을 누르면 True 이벤트가 전달됩니다.
        - darkBackgound: 에러 알럿의 배경을 어둡게 처리할 건지 전달합니다
     */
    func presentErrorAlert(
        error: Error?,
        finishSubject: PublishSubject<Bool>? = nil,
        darkBackground: Bool = false
    ) {
        
        var alert = ResultAlertView_Image_Title_Content_Alert(
            image: .warnning,
            title: "에러",
            content: "", 
            availableCancle: false,
            resultSubject: finishSubject
        )
        // TODO: - 리프레시 오류인경우 로그아웃 처리 
        if let error = error as? APIError {
            alert.content = error.errorDescription ?? ""
        } else {
            alert.content = "알 수 없는 에러\n고객센터로 문의해주세요"
        }
        
        self.presentResultAlertView_Image_Title_Content(
            source: self,
            alert: alert,
            darkbackground: darkBackground
        )
    }
    
}
