//
//  PortfolioLinkInputView.swift
//  TeamOne
//
//  Created by 강창혁 on 3/3/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class PortfolioLinkInputView: View {
    
    let nameInputView = PortfolioNameInputView()
    
    let URLInputView = PortolioURLInputView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        let stackView = UIStackView(arrangedSubviews: [nameInputView, URLInputView])
        stackView.axis = .vertical
        stackView.spacing = 15
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
    
