//
//  AppSettingView.swift
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

final class AppSettingView: View {
    
    private lazy var contentView = UIStackView().then {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let signOutButton = UIButton().then {
        $0.setButton(text: SettingType.AppSettingType.signOut.toName, typo: .button2, color: .teamOne.grayscaleEight)
        $0.contentHorizontalAlignment = .leading
    }
    
    private let deleteAccountButton = UIButton().then {
        $0.setButton(text: SettingType.AppSettingType.deleteAccout.toName, typo: .button2, color: .teamOne.grayscaleEight)
        $0.contentHorizontalAlignment = .leading
    }
    
    internal let appSettingTap = PublishRelay<SettingType.AppSettingType>()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        initLayout()
        makeSettingButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension AppSettingView {
    func makeSettingButtons() {
        for type in SettingType.AppSettingType.allCases {
            
            let button = UIButton().then {
                $0.setButton(text: type.toName, typo: .button2, color: .teamOne.grayscaleEight)
                $0.contentHorizontalAlignment = .leading
            }
            
            button.snp.makeConstraints {
                $0.height.equalTo(38)
            }
            
            contentView.addArrangedSubview(button)
            
            bindSettingButtons(button, type: type)
        }
    }
    
    func bindSettingButtons(
        _ button: UIButton,
        type: SettingType.AppSettingType) {
        
            button.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
                .map { type }
                .bind(to: appSettingTap)
                .disposed(by: disposeBag)
    }
}
