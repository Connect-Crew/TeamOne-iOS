//
//  MyProjectFooterView.swift
//  TeamOne
//
//  Created by Junyoung on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import DSKit

final class MyProjectFooterView: UICollectionReusableView {
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(24)
        }
    }
    
    func useFooter(_ use: Bool) {
        dividerView.isHidden = !use
    }
}
