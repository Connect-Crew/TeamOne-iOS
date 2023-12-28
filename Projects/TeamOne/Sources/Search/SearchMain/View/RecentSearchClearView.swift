//
//  RecentSearchClearView.swift
//  TeamOne
//
//  Created by Junyoung on 12/8/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class RecentSearchClearView: UIView {
    
    public let tapRecentHistoryClear = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    private let recentSearchLabel = UILabel().then {
        $0.setLabel(text: "최근 검색", typo: .button2, color: .teamOne.grayscaleSeven)
    }
    
    private let recentHistoryClearButton = UIButton().then {
        $0.setButton(text: "전체 삭제", typo: .button2, color: .teamOne.grayscaleSeven)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(recentSearchLabel)
        recentSearchLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(15)
        }
        
        addSubview(recentHistoryClearButton)
        recentHistoryClearButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(15)
        }
        
        recentHistoryClearButton.rx.tap
            .bind(to: tapRecentHistoryClear)
            .disposed(by: disposeBag)
    }
}
