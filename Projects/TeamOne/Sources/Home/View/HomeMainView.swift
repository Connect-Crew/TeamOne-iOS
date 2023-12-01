//
//  HomeMainView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/31.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import DSKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeMainView: UIView {

    lazy var headerMinHeight = 89.0 // 카테고리 높이(최소높이)
    lazy var headerViewWillDissmissHeight = 150.0
    lazy var headerMaxHeight = headerMinHeight + headerViewWillDissmissHeight // 카테고리 + 헤더 뷰 높이

    let navigationContainerView = UIView()

    let titleLabel = UILabel().then {
        $0.setLabel(text: "모집", typo: .largeTitle, color: .teamOne.grayscaleEight)
    }

    let notificationButton = UIButton().then {
        $0.setButton(image: .notification)
    }

    let searchButton = UIButton().then {
        $0.setButton(image: .search)
    }

    lazy var navigationButtonArray: [UIButton] = [notificationButton, searchButton]

    lazy var navigationButtonStackView = UIStackView(
        arrangedSubviews: navigationButtonArray
    ).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }

    let stickyHeaderView = UIView()

    let headerImageView = UIImageView().then {
        $0.image = .image(dsimage: .homeHeader)
        $0.contentMode = .scaleToFill
    }

    lazy var homeCategoryView = HomeCategoryView(selected: self.selected).then {
        $0.backgroundColor = .white
    }

    lazy var tableView = UITableView().then {
        // sticky를 구현하기 위해 Top에 max만큼 inset을 생성
        $0.contentInset = .init(top: self.headerMaxHeight, left: 0, bottom: 0, right: 0)
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        $0.backgroundColor = .teamOne.background
        $0.separatorStyle = .none
    }

    var viewEmpty = View_EmptyImageView_Label(text: "지원할 프로젝트가 없습니다", textColor: .teamOne.grayscaleFive, typo: .body3, image: .logo).then {
        $0.isHidden = true
    }

    var buttonWrite = UIButton().then {
        $0.setImage(.image(dsimage: .homeWriteButton), for: .normal)
    }

    let selected = BehaviorRelay<String?>(value: nil)

    init() {
        super.init(frame: .zero)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {

        self.backgroundColor = .teamOne.background

        layoutNavigation()
        layoutTableView()
        layoutStickyHeaderView()
        layoutButtonWrite()
    }

    func layoutNavigation() {
        addSubview(navigationContainerView)

        navigationContainerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        navigationContainerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().inset(17)
        }

        titleLabel.snp.contentHuggingHorizontalPriority = 749

        navigationButtonArray.forEach {
            $0.snp.contentHuggingHorizontalPriority = 750
        }

        navigationContainerView.addSubview(navigationButtonStackView)

        navigationButtonStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
    }

    func layoutTableView() {
        addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        addSubview(viewEmpty)

        viewEmpty.snp.makeConstraints {
            $0.centerX.equalTo(tableView)
            $0.centerY.equalTo(tableView).offset(headerMinHeight)
        }
    }

    func layoutStickyHeaderView() {

        addSubview(stickyHeaderView)

        stickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(navigationContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        stickyHeaderView.addSubview(headerImageView)

        headerImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(headerViewWillDissmissHeight)
            $0.leading.trailing.equalToSuperview()
        }

        stickyHeaderView.addSubview(homeCategoryView)

        homeCategoryView.snp.makeConstraints {
            $0.top.equalTo(headerImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(headerMinHeight)
            $0.bottom.equalToSuperview()
        }
    }

    func layoutButtonWrite() {
        addSubview(buttonWrite)

        buttonWrite.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
        }
    }
}
