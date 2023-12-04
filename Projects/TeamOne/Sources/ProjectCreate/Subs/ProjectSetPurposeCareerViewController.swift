//
//  ProjectSetPurposeCareerViewController.swift
//  TeamOne
//
//  Created by 강현준 on 12/4/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit
import SnapKit

final class ProjectSetPurposeCareerViewController: ViewController {

    let scrollView = BaseScrollView(frame: .zero)

    let labelPurposeTitle = UILabel().then {
        $0.setLabel(text: "프로젝트의 목적이 무엇인가요?", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let labelPurposeContent = UILabel().then {
        $0.setLabel(text: "두 가지 용도 중 하나를 선택해주세요.", typo: .caption2, color: .teamOne.grayscaleEight)
    }

    let buttonPurposeStartup = Button_IsSelected().then {
        $0.setTitle("예비창업", for: .normal)
    }

    let buttonPurposePortfolio = Button_IsSelected().then {
        $0.setTitle("포트폴리오", for: .normal)
    }

    let labelCareerTitle = UILabel().then {
        $0.setLabel(text: "선호하는 팀원들의 경력을 알려주세요.", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let labelCareerContent = UILabel().then {
        $0.setLabel(text: "취준생부터 경력 10년 이상까지 선택 가능합니다.", typo: .caption2, color: .teamOne.grayscaleEight)
    }

    let buttonBefore = UIButton().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.setButton(text: "이전", typo: .button1, color: .teamOne.grayscaleFive)
        $0.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        $0.setRound(radius: 8)
    }

    let buttonnoExperienceRequiredCheckBox = Button_CheckBox(text: "경력 무관", typo: .caption1, textColor: .teamOne.grayscaleSeven)
        .then {
            $0.type = .checkBox
            $0.isSelected = false
        }

    let buttonNext = Button_IsEnabled(enabledString: "다음", disabledString: "다음").then {
        $0.setRound(radius: 8)
        $0.isEnabled = false
        $0.setFont(typo: .button1)
    }

    lazy var contentStackView = UIStackView(arrangedSubviews: [
        createFirstStackView(),
        createSecondStackView()
    ]).then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }

    lazy var buttonStackView = UIStackView(arrangedSubviews: [
        buttonBefore,
        buttonNext
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.distribution = .fillEqually
        $0.spacing = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func layout() {
        self.view.addSubview(scrollView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.contentView.addSubview(contentStackView)

        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.view.addSubview(buttonStackView)

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonStackView.frame.height, right: 0)
    }

    func createFirstStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelPurposeTitle,
            labelPurposeContent,
            makeFirstButtonStackView()
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.setCustomSpacing(18, after: labelPurposeContent)
        }
    }

    func makeFirstButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            buttonPurposeStartup,
            buttonPurposePortfolio
        ])
        .then {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    }

    func createSecondStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelCareerTitle,
            labelCareerContent,
            buttonnoExperienceRequiredCheckBox
            //            makeFirstButtonStackView()
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.setCustomSpacing(18, after: labelPurposeContent)
        }
    }

}

