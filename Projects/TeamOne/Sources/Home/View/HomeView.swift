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

    // before과 after의 높이를 각 각 100으로 설정한 경우의 예시 수치
    // 최대높이는 Beforeheight + Afterheight
    // 최소높이는 Afterheight
    //    lazy var headerMaxHeight = 200.0
    //    lazy var headerMinHeight = 100.0

    lazy var headerMaxHeight = 150.0 + 89.0

    lazy var headerMinHeight = 89.0

    let headerView = UIView()

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

    let homeCategoryView = HomeCategoryView().then {
        $0.dataSource = HomeCategoryMocks.getDataSource()
        $0.backgroundColor = .teamOne.backgroundDefault
    }

    lazy var homeTableView = UITableView().then {
        $0.contentInset = .init(top: self.headerMaxHeight, left: 0, bottom: 0, right: 0)
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        $0.backgroundColor = .lightGray
        $0.separatorStyle = .none
    }

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

        addSubview(homeTableView)
        
        homeTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        addSubview(headerView)

        headerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.left.trailing.equalToSuperview()
        }

        headerView.addSubview(goToSeeProjectView)

        goToSeeProjectView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }

        headerView.addSubview(homeCategoryView)

        homeCategoryView.snp.makeConstraints {
            $0.top.equalTo(goToSeeProjectView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(89)
            $0.bottom.equalToSuperview()
        }
    }
}
