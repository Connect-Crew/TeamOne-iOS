//  TabBarView.swift
//  BaseFeatureDependency
//
//  Created by Junyoung Lee on 2023/08/17.
//  Copyright © 2023 Quriously. All rights reserved.
//

import UIKit
import SnapKit
import DSKit
import Then

public class TabBarView: UIView {

    let rootView = UIView()
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .lightOtherDivider
    }
    
    public let customTabBar = UIStackView().then {
        $0.backgroundColor = .lightBackgroundPaper
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        
    }

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(rootView)
        rootView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        rootView.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.top.equalToSuperview().inset(0)
        }
        
        rootView.addSubview(customTabBar)
        customTabBar.snp.makeConstraints { make in
            make.height.equalTo(74)
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalTo(dividerView.snp.bottom).offset(0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

