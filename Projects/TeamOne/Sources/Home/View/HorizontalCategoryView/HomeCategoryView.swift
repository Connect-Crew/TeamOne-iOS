//
//  BaseScrollView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/25.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class HomeCategoryView: UIScrollView {

    private var stackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        $0.spacing = 12
        $0.backgroundColor = .white
    }

    private var dataSource: [HomeCategoryModel]

    private let selected: BehaviorRelay<String?>

    private lazy var selectedCategory: HomeCategoryModel? = nil {
        didSet {
            selected.accept(selectedCategory?.type.selectedCategoryKey)
        }
    }

    private var buttons: [UIButton] = []

    init(selected: BehaviorRelay<String?>) {
        self.selected = selected
        self.dataSource = HomeCategoryMocks.getDataSource()
        super.init(frame: .zero)

        configure()
        bind()
        categoryButtonTapped(buttons.first)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        showsHorizontalScrollIndicator = false
        bounces = false
        self.backgroundColor = .white

        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(8)
        }
    }

    func bind() {
        dataSource.forEach {
            let button = UIButton()
            button.setImage($0.image, for: .normal)
            button.setImage($0.selectedImage, for: .selected)
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            button.tag = dataSource.firstIndex(of: $0) ?? 0

            stackView.addArrangedSubview(button)
            buttons.append(button)

            button.snp.makeConstraints {
                $0.height.equalTo(73)
            }
        }
    }

    @objc func categoryButtonTapped(_ sender: UIButton?) {

        guard let sender = sender else { return }

        buttons.forEach { $0.isSelected = false } // 모든 버튼을 비선택 상태로 설정
        sender.isSelected = true // 탭된 버튼을 선택된 상태로 설정
        if sender.tag < dataSource.count {
            selectedCategory = dataSource[sender.tag]
        }
    }

}

struct HomeCategoryModel: Equatable {

    enum CategoryModelType: String {
        case all
        case develop
        case planning
        case design
        case marketing
        case sales
        case customerservice
        case specialized
        case engineering
        case media
        case others

        var selectedCategoryKey: String? {
            switch self {
            case .all: return nil
            case .develop: return "TOTAL_DEVELOP"
            case .customerservice: return "TOTAL_CUSTOMER"
            case .design: return "TOTAL_DESIGN"
            case .engineering: return "TOTAL_ENGINEER"
            case .sales: return "TOTAL_SALES"
            case .planning: return "TOTAL_MANAGER"
            case .marketing: return "TOTAL_MARKETING"
            case .media: return "TOTAL_MEDIA"
            case .specialized: return "TOTAL_SPECIAL"
            case .others: return "ETC"
            }
        }
    }

    let type: CategoryModelType

    var image: UIImage? {
        switch type {
        case .all: return .image(dsimage: .categoryall)
        case .develop: return .image(dsimage: .categorydevelop)
        case .planning: return .image(dsimage: .categoryplanning)
        case .design: return .image(dsimage: .categorydesign)
        case .marketing: return .image(dsimage: .categorymarketing)
        case .sales: return .image(dsimage: .categorysales)
        case .specialized: return .image(dsimage: .categoryspecialize)
        case .customerservice: return .image(dsimage: .categorycustomerservice)
        case .engineering: return .image(dsimage: .categoryengineering)
        case .media: return .image(dsimage: .categorymedia)
        case .others: return .image(dsimage: .categoryothers)

        }
    }

    var selectedImage: UIImage? {
        switch type {
        case .all: return .image(dsimage: .categoryfillall)
        case .develop: return .image(dsimage: .categoryfilldevelop)
        case .planning: return .image(dsimage: .categoryfillplanning)
        case .design: return .image(dsimage: .categoryfilldesign)
        case .marketing: return .image(dsimage: .categoryfillmarketing)
        case .sales: return .image(dsimage: .categoryfillsales)
        case .specialized: return .image(dsimage: .categoryfillspecialize)
        case .customerservice: return .image(dsimage: .categoryfillcustomerservice)
        case .engineering: return .image(dsimage: .categoryfillengineering)
        case .media: return .image(dsimage: .categoryfillmedia)
        case .others: return .image(dsimage: .categoryfillothers)
        }
    }
}

struct HomeCategoryMocks {
    static func getDataSource() -> [HomeCategoryModel] {
        return [
            HomeCategoryModel(type: .all),
            HomeCategoryModel(type: .develop),
            HomeCategoryModel(type: .planning),
            HomeCategoryModel(type: .design),
            HomeCategoryModel(type: .marketing),
            HomeCategoryModel(type: .sales),
            HomeCategoryModel(type: .customerservice),
            HomeCategoryModel(type: .specialized),
            HomeCategoryModel(type: .engineering),
            HomeCategoryModel(type: .media),
            HomeCategoryModel(type: .others)
        ]
    }
}
