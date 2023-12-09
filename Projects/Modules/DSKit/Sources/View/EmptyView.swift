//
//  EmptyView.swift
//  DSKit
//
//  Created by Junyoung on 12/9/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core

final class EmptyView: UIView {
    
    private let emptyLabel = UILabel().then {
        $0.setLabel(text: "검색 결과가 없습니다.", typo: .body3, color: .teamOne.grayscaleFive)
    }
    
    private let emptyImage = UIImageView().then {
        $0.image = .image(dsimage: .emptyLogo)
    }
    
    private let containerStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [emptyImage, emptyLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        emptyImage.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
