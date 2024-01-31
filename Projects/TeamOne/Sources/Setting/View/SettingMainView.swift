//
//  SettingMainView.swift
//  TeamOne
//
//  Created by 강현준 on 1/30/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class SettingMainView: UIView {

    private let navigationView = SettingNavBar()
    
    private let scrollView = BaseScrollView()
    
    private let notificationSettingView = NotificationSettingView(frame: .zero)
    
    private let notificationLine = UIView().then {
        $0.setDivider(height: 1)
    }
    
    private let policySettingView = PolicySettingView(frame: .zero)
    
    private let policyLine = UIView().then {
        $0.setDivider(height: 1)
    }
    
    private let appSettingView = AppSettingView(frame: .zero)
    
    internal var backButtonTap: Observable<Void> {
        return navigationView.backButtonTap.map { _ in return () }
    }
    internal var appSettingTap: PublishRelay<AppSettingType> {
        return appSettingView.appSettingTap
    }
    internal var notificationSettingTap: PublishRelay<NotificationSettingType> {
        return notificationSettingView.notificationSettingTap
    }
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.contentView.addSubview(notificationSettingView)
        notificationSettingView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.contentView.addSubview(notificationLine)
        notificationLine.snp.makeConstraints {
            $0.top.equalTo(notificationSettingView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.contentView.addSubview(policySettingView)
        policySettingView.snp.makeConstraints {
            $0.top.equalTo(notificationLine.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.contentView.addSubview(policyLine)
        policyLine.snp.makeConstraints {
            $0.top.equalTo(policySettingView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.contentView.addSubview(appSettingView)
        appSettingView.snp.makeConstraints {
            $0.top.equalTo(policyLine.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    public func bind(output: SettingViewModel.Output) {
        notificationSettingView.bind(settings: output.notificationSetting)
    }
}
