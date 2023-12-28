//
//  ActiveItemsView.swift
//  TeamOne
//
//  Created by Junyoung on 12/16/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class ActiveItemsView: UIView {
    
    let titleLabel = UILabel().then {
        $0.setLabel(text: "마감된 것 제외", typo: .caption2, color: .teamOne.grayscaleSeven)
        $0.textAlignment = .right
    }
    
    let selectButton = UIButton().then {
        $0.setImage(.image(dsimage: .CheckBoxNotChecked), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        let containerView = UIView()
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(37)
        }
        
        containerView.addSubview(selectButton)
        selectButton.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(selectButton.snp.left).offset(-10)
//            make.left.equalToSuperview()
        }
        
    }
}
