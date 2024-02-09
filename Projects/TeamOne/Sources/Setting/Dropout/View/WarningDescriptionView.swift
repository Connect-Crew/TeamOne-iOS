//
//  WarningReasonView.swift
//  TeamOne
//
//  Created by 강창혁 on 2/8/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

final class WarningDescriptionView: UIView {
    
    private let warningImageView = UIImageView().then {
        $0.image = .image(dsimage: .warning)
    }
    
    private let warningDescriptionLabel = UILabel().then {
        $0.setLabel(text: "내용을 입력해주세요.", typo: .caption2, color: .teamOne.point)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(warningImageView)
        warningImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        addSubview(warningDescriptionLabel)
        warningDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(warningImageView.snp.trailing).offset(2)
            make.top.bottom.equalToSuperview().inset(1.5)
            make.trailing.equalToSuperview()
        }
    }
}
