//
//  DropoutMainView.swift
//  TeamOne
//
//  Created by 강창혁 on 2/7/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class DropoutMainView: UIView {
    
    private let navigationView = UIView()
    private let headerTitle = UILabel().then {
        $0.setLabel(text: "탈퇴하기", typo: .body1, color: .teamOne.grayscaleEight)
    }
    let backButton = UIButton().then {
        $0.setImage(.image(dsimage: .backButtonImage), for: .normal)
    }
    
    let headerView = DropoutHeaderView()
    let dropoutReasonView = DropoutReasonView()
    
    let dropoutButton = Button_IsEnabled_Dropout(enabledString: "탈퇴하기", disabledString: "탈퇴하기").then {
        $0.setRound(radius: 8)
        $0.setFont(typo: .button2)
        $0.isEnabled = false
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabel(text: "항상 건승하길 바라겠습니다. :)", typo: .caption1, color: .teamOne.grayscaleFive)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(navigationView)
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        navigationView.addSubview(backButton)
        navigationView.addSubview(headerTitle)
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        headerTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
        }
        addSubview(dropoutReasonView)
        dropoutReasonView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(63)
            make.centerX.equalToSuperview()
        }
        
        addSubview(dropoutButton)
        dropoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-9)
            make.centerX.equalToSuperview()
            make.width.equalTo(253)
            make.height.equalTo(50)
        }
    }
}
