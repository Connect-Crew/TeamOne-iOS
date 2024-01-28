//
//  ProfileMainView.swift
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

final class ProfileMainView: UIView {
    
    private let headerView = UIView()
    private let headerTitle = UILabel().then {
        $0.setLabel(text: "마이페이지", typo: .title1, color: .teamOne.grayscaleEight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        headerView.addSubview(headerTitle)
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
        }
    }
}
