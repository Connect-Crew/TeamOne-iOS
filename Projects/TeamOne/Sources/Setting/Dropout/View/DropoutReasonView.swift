//
//  DropoutReasonView.swift
//  TeamOne
//
//  Created by 강창혁 on 2/7/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

import Then
import DSKit
import SnapKit
import Core

final class DropoutReasonView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.setLabel(
            text: "김감자 님이 탈퇴하시려는 이유가 궁금해요.",
            typo: .body2,
            color: .teamOne.grayscaleEight
        )
    }
    
    private let subtitleLabel = UILabel().then {
        $0.setLabel(
            text: "좋은 서비스를 제공하지 못해 죄송합니다.",
            typo: .caption1,
            color: .teamOne.grayscaleFive
        )
    }
    
    private let notParticipateCheckBox = Button_CheckBox(
        text: "참여하고 싶은 프로젝트가 없어요.",
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    private let notUserCheckBox = Button_CheckBox(
        text: "유저가 많이 없어요.",
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    private let notTeamCheckBox = Button_CheckBox(
        text: "팀원이 잘 안 구해져요.",
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    private let badMannerCheckBox = Button_CheckBox(
        text: "비매너 유저가 있어요.",
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let newAccountCheckBox = Button_CheckBox(
        text: "새 계정을 만들고 싶어요.",
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private lazy var checkBoxStackView = UIStackView(arrangedSubviews: [
        notParticipateCheckBox,
        notUserCheckBox,
        notTeamCheckBox,
        badMannerCheckBox,
        newAccountCheckBox
    ]).then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    private let etcCheckBox = Button_CheckBox(
        text: "기타",
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let etcReasonTextField = TextField().then {
        $0.font = UIFont.setFont(font: .button2)
        $0.textColor = .teamOne.grayscaleSeven
    }
    
    private let etcTextFieldUnderLine = UIView().then {
        $0.backgroundColor = .teamOne.grayscaleSeven
    }
    
    let waringDescriptionView = WarningDescriptionView()
    
    
    
    private lazy var etcStackView = UIStackView(arrangedSubviews: [etcReasonTextField, etcTextFieldUnderLine, waringDescriptionView]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
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
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
        }
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
        }
        
        addSubview(checkBoxStackView)
        checkBoxStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
        }
        addSubview(etcCheckBox)
        etcCheckBox.snp.makeConstraints { make in
            make.top.equalTo(checkBoxStackView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(54)
            make.bottom.equalToSuperview()
        }
        addSubview(etcStackView)
        etcStackView.snp.makeConstraints { make in
            make.top.equalTo(etcCheckBox.snp.top)
            make.leading.equalTo(etcCheckBox.snp.trailing).offset(10)
        }
        
        etcTextFieldUnderLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(196)
        }
        
        etcReasonTextField.snp.makeConstraints { make in
            make.width.equalTo(196)
        }
    }
}
