//
//  MyProjectHeaderView.swift
//  TeamOne
//
//  Created by Junyoung on 2/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import DSKit

final class MyProjectHeaderView: UICollectionReusableView {
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
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
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.setLabel(text: text, typo: .body4, color: .teamOne.grayscaleEight)
    }
}
