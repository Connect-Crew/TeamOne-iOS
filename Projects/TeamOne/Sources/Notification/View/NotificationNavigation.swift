//
//  NotificationNavigationView.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class NotificationNavigationView: View {
    
    // MARK: - Components
    
    let titleLabel = UILabel().then {
        $0.setLabel(text: "알림", typo: .largeTitle, color: .teamOne.grayscaleEight)
    }
    
    lazy var contentView = UIStackView(arrangedSubviews: [
        titleLabel,
        UIView()
    ]).then {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 17, left: 24, bottom: 17, right: 24)
    }
    
    // MARK: - Inits
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func layout() {
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
