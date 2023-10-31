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

final class HomeCategoryView: UIScrollView {

    private var stackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        $0.spacing = 12
        $0.backgroundColor = .clear
    }

    var dataSource: [HomeCategoryModel]? {
        didSet {
            bind()
        }
    }

    lazy var selectedCategory: HomeCategoryModel? = dataSource?.first

    private var buttons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        showsHorizontalScrollIndicator = false
        bounces = false

        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
    }

    func bind() {
        dataSource?.forEach {
            let button = UIButton()
            button.setImage($0.image, for: .normal)
            button.setImage($0.selectedImage, for: .selected)
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            button.tag = dataSource?.firstIndex(of: $0) ?? 0

            stackView.addArrangedSubview(button)
            buttons.append(button)

            button.snp.makeConstraints {
                $0.height.equalTo(snp.height)
            }
        }
    }

    @objc func categoryButtonTapped(_ sender: UIButton) {
        buttons.forEach { $0.isSelected = false } // 모든 버튼을 비선택 상태로 설정
        sender.isSelected = true // 탭된 버튼을 선택된 상태로 설정
        if sender.tag < dataSource?.count ?? 0 {
            selectedCategory = dataSource?[sender.tag]
        }
    }

}

protocol CategoryViewProtocol {
    associatedtype EnumType
    var type: EnumType { get }
    var image: UIImage? { get }
    var selectedImage: UIImage? { get }
}

struct HomeCategoryModel: CategoryViewProtocol, Equatable {
    enum CategoryModelType: String {
        case all
        case develop
        case planning
        case design
        case marketing
        case sales
        case specialized
    }

    let type: CategoryModelType

    var name: String {
        type.rawValue
    }

    var image: UIImage? {
        switch type {
        case .all: return .image(dsimage: .categoryall)
        case .develop: return .image(dsimage: .categorydevelop)
        case .planning: return .image(dsimage: .categoryplanning)
        case .design: return .image(dsimage: .categorydesign)
        case .marketing: return .image(dsimage: .categorymarketing)
        case .sales: return .image(dsimage: .categorysales)
        case .specialized: return .image(dsimage: .categoryspecialize)
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
            HomeCategoryModel(type: .specialized)
        ]
    }
}
