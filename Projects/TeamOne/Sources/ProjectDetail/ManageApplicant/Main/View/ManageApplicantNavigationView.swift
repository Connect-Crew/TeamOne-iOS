//
//  ManageApplicantNavigationView.swift
//  TeamOne
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import SnapKit
import Then
import DSKit
import RxSwift
import RxCocoa

final class ManageApplicantNavigationView: View {
    
    private let buttonBack = UIButton().then {
        $0.setButton(image: .backButtonImage)
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabel(text: "지원자 관리", typo: .body1, color: .teamOne.grayscaleSeven)
        $0.textAlignment = .center
    }
    
    public let backButtonTap = PublishRelay<Void>()
    
    init() {
        super.init(frame: .zero)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.backgroundColor = .teamOne.white
        
        self.addSubview(buttonBack)
    
        buttonBack.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().offset(24)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bind() {
        buttonBack.rx.tap
            .bind(to: backButtonTap)
            .disposed(by: disposeBag)
    }
}
