//  BaseScrollableView.swift
//  BaseFeatureDependency
//
//  Created by Junyoung Lee on 2023/08/17.
//  Copyright © 2023 Quriously. All rights reserved.
//

import UIKit
import DSKit
import Then

open class BaseScrollableView: UIView {
    
    public let appBar = AppBarView()
    public let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    public let scrollView = UIScrollView()
    private let baseStackView: UIStackView = {
        let stack = UIStackView()
        stack.isUserInteractionEnabled = true
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LAYOUT
    open func layout() {
        addSubview(baseStackView)
        baseStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        [appBar, scrollView]
            .forEach {
                baseStackView.addArrangedSubview($0)
            }
                
        scrollView.addSubview(contentView)
        
        appBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
    }
}
