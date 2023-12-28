//
//  HistoryEmptyView.swift
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

public final class HistoryEmptyView: UIView {
    
    private let emptyLabel = UILabel().then {
        $0.setLabel(text: "검색 결과가 없습니다.", typo: .body3, color: .teamOne.grayscaleFive)
        $0.textAlignment = .center
    }
    
    private let emptyImage = UIImageView().then {
        $0.image = .image(dsimage: .emptyLogo)
    }
    
    private let containerView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .white
        
        containerView.addSubview(emptyImage)
        emptyImage.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        containerView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(emptyImage.snp.bottom).offset(24)
        }
        
        addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
}
