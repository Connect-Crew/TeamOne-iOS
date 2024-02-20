//
//  FavoriteProjectNavBar.swift
//  TeamOne
//
//  Created by 강현준 on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class FavoriteProjectNavBar: View {
    
    private let headerTitle = UILabel().then {
        $0.setLabel(text: "관심 프로젝트", typo: .body1, color: .teamOne.grayscaleEight)
        $0.textAlignment = .center
    }
    
    private let backButton = UIButton().then {
        $0.setImage(.image(dsimage: .backButtonImage), for: .normal)
    }
    
    var backButttonTap: Observable<Void> {
        return backButton.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
    }
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        self.addSubview(headerTitle)
        headerTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
}
