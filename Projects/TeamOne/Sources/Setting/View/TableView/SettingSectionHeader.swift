//
//  SettingSectionHeader.swift
//  TeamOne
//
//  Created by 강현준 on 2/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit
import Domain

final class SettingSectionHeader: View {
    
    private lazy var titleLabel = UILabel().then {
        $0.setLabel(text: "알림 설정", typo: .body4, color: .teamOne.grayscaleEight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(SettingMainView.CellInset.leading)
            $0.trailing.equalToSuperview().inset(SettingMainView.CellInset.trailing)
            $0.centerY.equalToSuperview()
        }
        
        self.backgroundColor = .teamOne.white
    }
    
    func initSeting(with title: String) {
        self.titleLabel.text = title
    }
}
