//
//  SettingBaseCell.swift
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

final class SettingBaseCell: UITableViewCell {
    
    private lazy var titleLabel = UILabel().then {
        $0.setLabel(text: "공습경보", typo: .button2, color: .teamOne.grayscaleEight)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(SettingMainView.CellInset.leading)
            $0.trailing.equalToSuperview().inset(SettingMainView.CellInset.trailing)
            $0.centerY.equalToSuperview()
        }
        
        self.selectionStyle = .none
    }
    
    func initSeting(with title: String) {
        self.titleLabel.text = title
    }
}


