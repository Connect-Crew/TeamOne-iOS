//
//  TosView.swift
//  TeamOne
//
//  Created by 임재현 on 2023/11/01.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import DSKit
import SnapKit
import RxSwift
import RxCocoa

final class TosView: UIView {
    
    let disposeBag = DisposeBag()

    let viewNavigationContainer = UIView()

    let labelNavigationTitle = UILabel().then {
        $0.setLabel(text: "약관 동의", typo: .body1, color: .teamOne.grayscaleEight)
    }

    let leftBackButton = UIButton().then {
        $0.setImage(.image(dsimage: .backButtonImage), for: .normal)
    }

    let buttonClose = UIButton().then {
        $0.setImage(.image(dsimage: .closeButtonX), for: .normal)
    }

    let viewContentContainer = UIView()

    let labelMainTitle = UILabel().then {
        $0.setLabel(text: "약관을 확인해주세요.", typo: .title1, color: .teamOne.grayscaleEight)
    }

    let labelExplain = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabel(text: "팀원을 보다 안전하고 즐겁게 이용하기 위한 약관이 \n에요. 약관 동의 후 회원가입이 시작됩니다.", typo: .body3, color: .teamOne.grayscaleFive)
    }

    let buttonAllCheckBox = Button_CheckBox(text: "전체 동의하기", typo: .body2, textColor: .teamOne.grayscaleEight).then {
        $0.setButton(image: .checkNONOE)
    }

    let dividerView = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleFive)
    }

    let buttonUserServiceTermsCheckBox = Button_CheckBox(text: "서비스 이용 약관", typo: .button2, textColor: .teamOne.grayscaleEight).then {
        $0.snp.contentHuggingHorizontalPriority = 241
    }

    let buttonGoUserServiceTerms = UIButton().then {
        $0.setButton(image: .rightButton)
        $0.snp.contentHuggingHorizontalPriority = 241
    }

    let buttonUserPersonalInfoPolicyCheckBox = Button_CheckBox(text: "개인정보 처리방침", typo: .button2, textColor: .teamOne.grayscaleEight).then {

        $0.snp.contentHuggingHorizontalPriority = 240
    }

    let buttonGoUserPersonalInfoPolicy = UIButton().then {
        $0.setButton(image: .rightButton)
        $0.snp.contentHuggingHorizontalPriority = 241

    }

    let buttonNext = Button_IsEnabled(enabledString: "다음", disabledString: "다음").then {
        $0.setButton(text: "다음", typo: .button1, color: .teamOne.grayscaleTwo)

        $0.isEnabled = false
        $0.setRound(radius: 8)
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
        addSubview(viewNavigationContainer)

        viewNavigationContainer.snp.makeConstraints {
            $0.top.left.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }

        [leftBackButton, labelNavigationTitle, buttonClose].forEach {
            viewNavigationContainer.addSubview($0)
        }

        leftBackButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }

        labelNavigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        buttonClose.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }

        addSubview(viewContentContainer)

        viewContentContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(viewNavigationContainer.snp.bottom)
            $0.bottom.equalToSuperview()
        }

        [
            labelMainTitle, labelExplain, buttonAllCheckBox, dividerView, buttonUserServiceTermsCheckBox, buttonGoUserServiceTerms, buttonUserPersonalInfoPolicyCheckBox, buttonGoUserPersonalInfoPolicy, buttonNext
        ].forEach {
            viewContentContainer.addSubview($0)
        }

        labelMainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(38)
            $0.leading.trailing.equalToSuperview()
        }

        labelExplain.snp.makeConstraints {
            $0.top.equalTo(labelMainTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        buttonAllCheckBox.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(labelExplain.snp.bottom).offset(38.5)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(buttonAllCheckBox.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        buttonUserServiceTermsCheckBox.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(24)
        }

        buttonGoUserServiceTerms.snp.makeConstraints {
            $0.leading.equalTo(buttonUserServiceTermsCheckBox.snp.trailing)
            $0.centerY.equalTo(buttonUserServiceTermsCheckBox)
            $0.trailing.equalToSuperview()
        }

        buttonUserPersonalInfoPolicyCheckBox.snp.makeConstraints {
            $0.top.equalTo(buttonGoUserServiceTerms.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
        }

        buttonGoUserPersonalInfoPolicy.snp.makeConstraints {
            $0.leading.equalTo(buttonUserPersonalInfoPolicyCheckBox.snp.trailing)
            $0.centerY.equalTo(buttonUserPersonalInfoPolicyCheckBox)
            $0.trailing.equalToSuperview()
        }

        buttonNext.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview()
        }

    }
}
