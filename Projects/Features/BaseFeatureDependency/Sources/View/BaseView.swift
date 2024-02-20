//  BaseView.swift
//  BaseFeatureDependency
//
//  Created by Junyoung Lee on 2023/08/17.
//  Copyright © 2023 Quriously. All rights reserved.
//

import UIKit
import DSKit

open class BaseView: UIView {

    public let appBar = AppBarView()
    public let contentView = UIView()
    private let baseStackView: UIStackView = {
        let stack = UIStackView()
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
        baseStackView.isSkeletonable = true
        contentView.isSkeletonable = true
        
        addSubview(baseStackView)
        appBar.addBottomShadow(.elevationOne)
        baseStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        [appBar, contentView]
            .forEach {
                baseStackView.addArrangedSubview($0)
            }
                
        appBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
    }
}
