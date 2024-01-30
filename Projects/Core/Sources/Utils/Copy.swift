//
//  Copy.swift
//  Core
//
//  Created by 강현준 on 1/29/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit

public extension NSUtil {
    class Copy {
        
        static var indicator = PaddingLabel().then {
            $0.text = "클립보드에 복사되었습니다."
            $0.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            $0.sizeToFit()
            $0.backgroundColor = UIColor.init(red: 0/255, green: 174/255, blue: 228/255, alpha: 1.0)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = $0.intrinsicContentSize.height / 2
            $0.clipsToBounds = true
            $0.textColor = .white
        }
        
        public static func textCopy(target: String?) {
            
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                
                window.addSubview(indicator)
                
                indicator.snp.makeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.bottom.equalToSuperview().inset(200)
                }
            }
            
            UIPasteboard.general.string = target
            
            UIView.animate(withDuration: 0.5, animations: {
                indicator.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 1.5, animations: {
                    indicator.alpha = 0
                }, completion: { _ in
                    indicator.removeFromSuperview()
                    indicator.snp.removeConstraints()
                })
            })
        }
        
    }
}
