//
//  SettingNavBar.swift
//  TeamOne
//
//  Created by 강현준 on 1/30/24.
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

final class SettingNavBar: View {
    
    private let backButton = UIButton().then {
        $0.setImage(.image(dsimage: .backButtonImage), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabel(text: "설정", typo: .body1, color: .teamOne.grayscaleEight)
    }
    
    public var backButtonTap: Observable<Void> {
        return backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    init() {
        super.init(frame: .zero)
        
        initAttribute()
        initConstraint()
    }
    
    private func initAttribute() {
        titleLabel.textAlignment = .center
    }
    
    private func initConstraint() {
        
        addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
