//
//  Setting+Switch.swift
//  DSKit
//
//  Created by 강현준 on 1/30/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core
import SnapKit
import Then

/**
 설정화면에 사용되는 텍스트 + 스위치 컴포넌트입니다.
 */
public final class Setting_Switch: UIView {
    
    private let titleLabel = UILabel().then {
        $0.setLabel(text: "", typo: .button2, color: .teamOne.grayscaleEight)
    }
    
    private let controlSwitch = TOTogle(type: .small)
    
    public init(title: String, isOn: Bool) {
        super.init(frame: .zero)
        
        initLayout()
        initSetting(title: title, isOn: isOn)
    }
    
    public var tap: Observable<Void> {
        return controlSwitch.rx.tap
    }
    
    public var isOn: ControlProperty<Bool> {
        return controlSwitch.rx.isOn
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
        }
        
        titleLabel.snp.contentHuggingHorizontalPriority = 750
        controlSwitch.snp.contentHuggingHorizontalPriority = 745
        
        self.addSubview(controlSwitch)
        controlSwitch.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
    }
    
    /// 스위치의 isOn상태를 변경합니다.
    public func setIsOn(isOn: Bool) {
        self.controlSwitch.isOn = isOn
    }
    
    public func initSetting(title: String, isOn: Bool) {
        self.titleLabel.text = title
        self.controlSwitch.isOn = isOn
    }
}

