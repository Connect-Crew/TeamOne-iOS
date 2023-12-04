//
//  ProjectCreateMainView.swift
//  TeamOne
//
//  Created by 강현준 on 12/1/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class ProjectCreateMainView: UIView {

    let buttonClose = UIButton().then {
        $0.setImage(.image(dsimage: .closeButtonX), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
    }

    lazy var navigation = UIStackView(arrangedSubviews: [
        UIView(),
        buttonClose
    ])

    let stepIndicatorView = StepIndicatorView().then {
        $0.totalStep = 5
        $0.titles = ["이름", "기간/장소", "목적/경력", "분야", "게시물 작성"]
        $0.currentStep = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        layoutNavigation()
        layoutIndicator()
    }

    private func layoutNavigation() {
        self.addSubview(navigation)

        navigation.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func layoutIndicator() {
        self.addSubview(stepIndicatorView)

        stepIndicatorView.snp.makeConstraints {
            $0.top.equalTo(navigation.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

    }
}
