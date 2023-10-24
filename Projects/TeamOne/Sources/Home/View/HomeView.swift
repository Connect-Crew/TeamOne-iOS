//
//  HomeViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import DSKit
import SnapKit

final class HomeView: UIView {

    let titleLabel = UILabel().then {
        $0.setLabel(text: "모집", typo: .largeTitle, color: .teamOne.grayscaleEight)
    }

    let filterButton = UIButton().then {
        $0.setButton(image: .slider)
    }

    let searchButton = UIButton().then {
        $0.setButton(image: .search)
    }

    let goToSeeProjectView = GoToSeeProjectView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {

        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(safeAreaLayoutGuide).offset(17)
        }

        let rightBarButtonStackView = UIStackView(arrangedSubviews: [filterButton, searchButton]).then {
            $0.axis = .horizontal
            $0.spacing = 12
        }

        addSubview(rightBarButtonStackView)

        rightBarButtonStackView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(18)
        }

        addSubview(goToSeeProjectView)

        goToSeeProjectView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }
    }
}
