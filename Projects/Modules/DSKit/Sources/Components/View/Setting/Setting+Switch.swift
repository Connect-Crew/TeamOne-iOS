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
    
    private lazy var contentView = UIStackView(arrangedSubviews: [
        titleLabel,
        controlSwitch
    ]).then {
        $0.spacing = 10
        $0.alignment = .center
    }
    
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
        
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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

