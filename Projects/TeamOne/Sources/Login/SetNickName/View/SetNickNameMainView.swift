//
//  SetNickNameMainView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit

final class SetNickNameMainView: UIView {
    let viewNavigationContainer = UIView()

    let labelNavigationTitle = UILabel().then {
        $0.textAlignment = .center
        $0.snp.contentHuggingHorizontalPriority = 250
        $0.setLabel(text: "회원 가입", typo: .body1, color: .teamOne.grayscaleEight)
    }

    let buttonNavigationLeft = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
        $0.snp.contentHuggingHorizontalPriority = 251
        $0.setImage(.image(dsimage: .backButtonImage), for: .normal)
    }

    let buttonNavigationRight = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
        $0.snp.contentHuggingHorizontalPriority = 251
        $0.setImage(.image(dsimage: .closeButtonX), for: .normal)
    }

    let labelSetNickName = UILabel().then {
        $0.setLabel(text: "닉네임을 설정해주세요", typo: .title1, color: .teamOne.grayscaleEight)
    }

    let labelContent = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabel(text: "팀원에서 사용할 닉네임을 만들어주세요. \n건강한 프로젝트 모임을 만들어 나가요!", typo: .body3, color: .teamOne.grayscaleFive)
    }

    let labelNickname = UILabel().then {
        $0.setLabel(text: "닉네임", typo: .body1, color: .teamOne.grayscaleEight)
    }

    let textFieldNickName = TextField_SetNickName()

    let viewUnderBar = View_UnderBar(frame: .zero)

    let labelExplane = UILabel().then {
        $0.setLabel(text: "", typo: .caption2, color: .teamOne.point)
    }

    let buttonNext = Button_IsEnabled(enabledString: "다음", disabledString: "다음").then {
        $0.setRound(radius: 8)
        $0.setButton(text: "다음", typo: .button1, color: .black)
        $0.isEnabled = false
    }

    lazy var navigationView = createNavigation()

    lazy var contentView = UIStackView(
        arrangedSubviews: [createContentStackView(), createTextViewStackView(), UIView()]
    ).then {
        $0.axis = .vertical
        $0.spacing = 33

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        layoutNavigation()
        layoutContentView()

        addSubview(buttonNext)

        buttonNext.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(64)
        }
    }

    private func layoutNavigation() {
        addSubview(navigationView)

        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func layoutContentView() {
        addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(31)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }

        textFieldNickName.snp.makeConstraints {
            $0.height.equalTo(31)
        }
    }

    private func createNavigation() -> UIStackView {

        let navigationStackView = UIStackView(arrangedSubviews: [buttonNavigationLeft, labelNavigationTitle, buttonNavigationRight]).then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.spacing = 0
        }

        return navigationStackView
    }

    private func createContentStackView() -> UIStackView {
        let contentStackView = UIStackView(arrangedSubviews: [ labelSetNickName, labelContent]).then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 16
        }

        return contentStackView
    }

    private func createTextViewStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [labelNickname, textFieldNickName, viewUnderBar, labelExplane]).then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 1
        }

        return stackView
    }
}
