//
//  AlertSettingView.swift
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
import Domain
import Core

final class NotificationSettingView: View {
    
    private lazy var contentView = UIStackView().then {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let setAlertTitleLabel = PaddingLabel().then {
        $0.setLabel(text: "알림 설정", typo: .body4, color: .teamOne.grayscaleEight)
        $0.textInsets = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    private let activitySetting = Setting_Switch(
        title: SettingType.NotificationSettingType.activity.toName,
        isOn: false
    )
    
    var notificationSettingTap = PublishRelay<NotificationSettingType>()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        initLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addArrangedSubview(setAlertTitleLabel)
        contentView.addArrangedSubview(activitySetting)
    }
    
    public func bind(settings: Driver<NotificationSettings>) {
        settings
            .drive(onNext: { [weak self] setting in
                self?.activitySetting.setIsOn(isOn: setting.activitySetting)
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        activitySetting.tap
            .map { _ in .activity }
            .bind(to: notificationSettingTap)
            .disposed(by: disposeBag)
    }
}
