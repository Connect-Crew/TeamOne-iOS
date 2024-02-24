//
//  ProfileEditNavBar.swift
//  TeamOne
//
//  Created by 강창혁 on 2/24/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class ProfileEditNavBar: View {
    
    private let headerTitle = UILabel().then {
        $0.setLabel(text: "프로필 수정", typo: .body2, color: .teamOne.grayscaleEight)
        $0.textAlignment = .center
    }
    
    private let backButton = UIButton().then {
        $0.setImage(.image(dsimage: .backButtonImage), for: .normal)
    }
    
    var backButttonTap: Observable<Void> {
        return backButton.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
    }
    
    private let completeButton = UIButton().then {
        $0.setButton(text: "완료", typo: .button2, color: .teamOne.mainColor)
        $0.setTitleColor(.teamOne.grayscaleFive, for: .disabled)
        $0.isEnabled = false
    }
    
    var completeButtonTap: Observable<Void> {
        return completeButton.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
    }
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        self.addSubview(headerTitle)
        headerTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        self.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(29)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
            $0.width.equalTo(30)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyShadow(offsetX: 0, offsetY: 4, blurRadius: 8, color: .init(r: 189, g: 189, b: 189, a: 1), opacity: 0.3, positions: [.bottom])
    }
}
