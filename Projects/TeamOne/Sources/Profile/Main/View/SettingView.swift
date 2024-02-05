//
//  SettingView.swift
//  TeamOne
//
//  Created by Junyoung on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class SettingView: UIView {
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    
    private let settingItems = SettingType.allCases
    
    private let disposeBag = DisposeBag()
    
    public let settingType = PublishSubject<SettingType>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        settingItems
            .forEach { type in
                let view = createView(type)
                contentStackView.addArrangedSubview(view)
            }
    }
}

extension SettingView {
    private func createView(_ type: SettingType) -> UIView {
        let view = UIView()
        
        let label = UILabel().then {
            $0.setLabel(text: type.toName, typo: .button2, color: .teamOne.grayscaleEight)
        }
        
        let button = UIButton()
        
        view.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.rx.tap
            .map { type }
            .bind(to: settingType)
            .disposed(by: disposeBag)
        
        return view
    }
}
