//
//  ProjectDetailNavigation.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import DSKit
import SnapKit
import Core
import UIKit

final class ProjectDetailNavigation: UIView {

    let buttonNavigationLeft = UIButton().then {
        $0.contentHorizontalAlignment = .leading
        $0.setImage(.image(dsimage: .backButtonImage), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 10)
    }

    let buttonNavigationRight = UIButton().then {
        $0.contentHorizontalAlignment = .trailing
        $0.setImage(.image(dsimage: .threedot), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
    }

    private lazy var navigationStackView = UIStackView(arrangedSubviews: [buttonNavigationLeft, buttonNavigationRight]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        addSubview(navigationStackView)

        navigationStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
