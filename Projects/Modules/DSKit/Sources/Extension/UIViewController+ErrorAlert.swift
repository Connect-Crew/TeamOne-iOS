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
    var presentErrorAlert: Binder<Error> {
        return Binder(self.base) { base, error in
            base.presentErrorAlert(
                error: error, finishSubject: nil
            )
        }
    }
}

public extension UIViewController {
    
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
        
        if let error = error as? APIError {
            
            switch error {
                
            case .network:
                alert.content = error.errorDescription ?? ""
                
            case .notToken:
                alert.content = error.errorDescription ?? ""
                
            case .decodingError:
                alert.content = error.errorDescription ?? ""
                
            case .unknown:
                alert.content = error.errorDescription ?? ""

            }
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
