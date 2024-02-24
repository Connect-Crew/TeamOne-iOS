//
//  ProfileEditMainView.swift
//  TeamOne
//
//  Created by 강창혁 on 2/24/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class ProfileEditMainView: View {
    
    let navBar = ProfileEditNavBar()
    
    private let scrollView = BaseScrollView()
    
    init() {
        super.init(frame: .zero)
        layout()
        scrollView.backgroundColor = .teamOne.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutNavBar()
        layoutScrollView()
    }
    
    private func layoutNavBar() {
        self.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.contentView.backgroundColor = .teamOne.background
    }
}
