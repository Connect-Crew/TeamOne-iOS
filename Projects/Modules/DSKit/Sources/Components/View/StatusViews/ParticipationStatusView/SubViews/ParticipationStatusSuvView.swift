//
//  ParticipationStatusSuvView.swift
//  DSKit
//
//  Created by 강현준 on 2/13/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import Then

internal final class ParticipationStatusSuvView: UIView {
    
    let countLabel = UILabel().then {
        $0.setLabel(text: "0", typo: .body4, color: .teamOne.grayscaleEight)
        $0.textAlignment = .center
    }
    
    let titleLabel = UILabel().then {
        $0.setLabel(text: "땡땡땡", typo: .caption2, color: .teamOne.grayscaleFive)
        $0.textAlignment = .center
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
        }
    }
}
