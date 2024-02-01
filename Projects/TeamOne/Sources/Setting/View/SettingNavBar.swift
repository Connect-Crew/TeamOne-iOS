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
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabel(text: "설정", typo: .body1, color: .teamOne.grayscaleEight)
        $0.textAlignment = .center
    }
    
    public var backButtonTap: Observable<Void> {
        return backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    init() {
        super.init(frame: .zero)
        
        initConstraint()
    }
    
    private func initConstraint() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
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
