//
//  SearchHeaderView.swift
//  TeamOne
//
//  Created by Junyoung on 12/6/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DSKit

final class SearchHeaderView: UIView {
    
    private let backButton = UIButton().then {
        $0.setImage(.image(dsimage: .backButtonImage), for: .normal)
    }
    
    private let searchTextField = SearchTextField()
    
    private let searchButton = UIButton().then {
        $0.setImage(.image(dsimage: .search), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    private let disposeBag = DisposeBag()
    public let tapBack = PublishSubject<Void>()
    public let tapSearch = PublishSubject<Void>()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        // MARK: Back Button
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.left.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(9)
        }
        
        // MARK: TextField
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(6.5)
            make.top.bottom.equalToSuperview().inset(7)
        }
        
        // MARK: Search Button
        addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.left.equalTo(searchTextField.snp.right).offset(6.5)
            make.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(9)
        }
        
        self.setBaseShadow(radius: 8)
        
        backButton.rx.tap
            .bind(to: tapBack)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: tapSearch)
            .disposed(by: disposeBag)
    }
}
