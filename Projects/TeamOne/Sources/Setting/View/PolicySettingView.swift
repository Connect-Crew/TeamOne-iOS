//
//  PolicySettingView.swift
//  TeamOne
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DSKit
import Core

final class PolicySettingView: View {
    
    private lazy var contentView = UIStackView().then {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let policyTitleLabel = PaddingLabel().then {
        $0.setLabel(text: "정책 관련", typo: .body4, color: .teamOne.grayscaleEight)
        $0.textInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    private let termsOfServiceButton = UIButton().then {
        $0.setButton(text: "서비스 이용약관", typo: .button2, color: .teamOne.grayscaleEight)
        $0.contentHorizontalAlignment = .leading
    }
    
    private let privacyPolicyButton = UIButton().then {
        $0.setButton(text: "개인정보 처리방침", typo: .button2, color: .teamOne.grayscaleEight)
        $0.contentHorizontalAlignment = .leading
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addArrangedSubview(policyTitleLabel)
        
        contentView.addArrangedSubview(termsOfServiceButton)
        
        contentView.addArrangedSubview(privacyPolicyButton)
        
        [termsOfServiceButton, privacyPolicyButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(38)
            }
        }

    }
}
