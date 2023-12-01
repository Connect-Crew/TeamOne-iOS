//
//  DetailMainCategoryView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit
import DSKit
import RxSwift

enum DetailMainCategory {
    case introduction
    case teamMembers
    case chat
}

final class DetailMainCategoryView: UIView {

    var buttonArray: [UIButton] = []

    let selectedUnderBar = UIView().then {
        $0.setRound(radius: 2)
        $0.setDivider(height: 1, color: .teamOne.mainColor)
    }

    var stackView = UIStackView(arrangedSubviews: []).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    var categorySelectedSubject = BehaviorSubject<Int>(value: 0)

    let categories: [DetailMainCategory] = [.introduction, .teamMembers, .chat]

    init() {

        super.init(frame: .zero)

        categories.forEach { category in
            let button = UIButton().then { button in

                switch category {
                case .introduction:
                    button.setButton(text: "소개", typo: .body3, color: .teamOne.grayscaleFive)
                case .teamMembers:
                    button.setButton(text: "팀원", typo: .body3, color: .teamOne.grayscaleFive)
                case .chat:
                    button.setButton(text: "채팅", typo: .body3, color: .teamOne.grayscaleFive)
                }

                button.setTitleColor(.teamOne.mainColor, for: .selected)

                button.isSelected = false

                buttonArray.append(button)

                button.adjustsImageWhenHighlighted = false
            }
        }

        stackViewInitSetting()
        buttonsInitSetting()
        underBarInitSetting()
        selectCategory(index: 0)
    }

    func selectCategory(index: Int) {
        if index < categories.count {
            buttonArray.forEach { $0.isSelected = false}
            buttonArray[index].isSelected = true

            UIView.animate(withDuration: 0.1) { [weak self] in

                self?.selectedUnderBar.snp.remakeConstraints {
                    $0.leading.trailing.equalTo(self?.buttonArray[index] ?? 0)
                    $0.bottom.equalTo(self?.stackView.snp.bottom ?? 0)
                    $0.height.equalTo(2)
                }

                self?.layoutIfNeeded()
            }

            categorySelectedSubject.onNext(index)
        }
    }

    private func stackViewInitSetting() {

        stackView.addArrangeSubViews(views: buttonArray)

        self.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }

    private func buttonsInitSetting() {
        buttonArray.enumerated().forEach { index, button in
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            button.tag = index
        }
    }

    private func underBarInitSetting() {
        self.addSubview(selectedUnderBar)

        selectedUnderBar.snp.makeConstraints {
            $0.bottom.equalTo(stackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }

    @objc func categoryButtonTapped(_ sender: UIButton) {
        selectCategory(index: sender.tag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
