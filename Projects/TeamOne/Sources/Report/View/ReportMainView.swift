//
//  ReportMainView.swift
//  TeamOne
//
//  Created by Junyoung on 3/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

enum OtherState {
    case error
    case edit
    case enable(Bool)
}

final class ReportMainView: UIView {
    
    let mainViewContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let reportTitle = UILabel().then {
        $0.setLabel(text: "김감자 님의 신고 사유를 알려주세요.", typo: .body2, color: .grayscaleEight)
        $0.textAlignment = .center
    }
    
    private let reportStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    let abusiveLanguage = Button_CheckBox(text: "욕설 / 비하발언", typo: .button2, textColor: .grayscaleSeven, type: .checkBoxBlue).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    let lowParticipation = Button_CheckBox(text: "참여율 저조\n(응답률, 접속률, 투표 진행 등)", typo: .button2, textColor: .grayscaleSeven, type: .checkBox).then {
        $0.checkedTextColor = .teamOne.mainColor
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    let spamming = Button_CheckBox(text: "프로젝트 생성, 채팅 등 도배", typo: .button2, textColor: .grayscaleSeven, type: .checkBox).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    let promotionalContent = Button_CheckBox(text: "홍보성 컨텐츠", typo: .button2, textColor: .grayscaleSeven, type: .checkBox).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    let inappropriateNicknameOrProfilePhoto = Button_CheckBox(text: "부적절한 닉네임 / 프로필 사진", typo: .button2, textColor: .grayscaleSeven, type: .checkBox).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    let privacyInvasion = Button_CheckBox(text: "개인 사생활 침해", typo: .button2, textColor: .grayscaleSeven, type: .checkBox).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    let adultContent = Button_CheckBox(text: "19+ 음란성, 만남 유도", typo: .button2, textColor: .grayscaleSeven, type: .checkBox).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    let otherView = UIView()
    
    let otherTextField = UITextField().then {
        $0.font = .setFont(font: .button2)
        $0.textColor = .teamOne.grayscaleFive
    }
    
    let otherTextUnderLineView = UIView().then {
        $0.backgroundColor = .grayscaleSeven
        $0.layer.cornerRadius = 2
    }
    
    let other = Button_CheckBox(text: "기타", typo: .button2, textColor: .grayscaleSeven, type: .checkBox)
    
    let errorView = UIView()
    let errorImageView = UIImageView().then {
        $0.image = .image(dsimage: .warning)
        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
    }
    let errorText = UILabel()
    
    let cancelButton = UIButton().then {
        $0.setButton(text: "취소", typo: .button2, color: .grayscaleSeven)
        $0.backgroundColor = .grayscaleTwo
    }
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let confirmButton = UIButton().then {
        $0.setButton(text: "내보내기", typo: .button2, color: .white)
        $0.backgroundColor = .mainColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = UIColor(r: 66, g: 66, b: 66, a: 0.6)
        mainViewContainer.backgroundColor = UIColor(r: 253, g: 253, b: 253, a: 1)
        errorView.isHidden = true
        
        addSubviews()
        makeLayouts()
    }
}

extension ReportMainView {
    private func addSubviews() {
        addSubview(mainViewContainer)
        mainViewContainer.addSubview(reportTitle)
        
        errorView.addSubview(errorImageView)
        errorView.addSubview(errorText)
        
        otherView.addSubview(other)
        otherView.addSubview(otherTextField)
        otherView.addSubview(otherTextUnderLineView)
        
        [
            abusiveLanguage,
            lowParticipation,
            spamming,
            promotionalContent,
            inappropriateNicknameOrProfilePhoto,
            privacyInvasion,
            adultContent,
            otherView,
            errorView
        ].forEach {
            reportStackView.addArrangedSubview($0)
        }
        
        mainViewContainer.addSubview(reportStackView)
        
        [cancelButton, confirmButton].forEach {
            bottomStackView.addArrangedSubview($0)
        }
        
        mainViewContainer.addSubview(bottomStackView)
    }
    
    private func makeLayouts() {
        mainViewContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(45)
        }
        
        reportTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(24)
        }
        
        other.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(54)
        }
        
        otherTextField.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(other.snp.right).offset(10)
        }
        
        otherTextUnderLineView.snp.makeConstraints { make in
            make.left.right.equalTo(otherTextField)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        reportStackView.snp.makeConstraints { make in
            make.top.equalTo(reportTitle.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(reportStackView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
    }
}

extension ReportMainView {
    func setReportName(_ name: String) {
        reportTitle.setLabel(text: "\(name) 님의 신고 사유를 알려주세요.", typo: .body2, color: .grayscaleEight)
    }
    
    func setErrorState(error: Bool, msg: String) {
        errorView.isHidden = !error
    }
    
    func setOtherState(_ state: OtherState) {
        switch state {
        case .error:
            otherTextUnderLineView.backgroundColor = .point
        case .edit:
            otherTextUnderLineView.backgroundColor = .mainColor
        case .enable(let isEnable):
            otherTextField.isEnabled = isEnable
            otherTextUnderLineView.backgroundColor = .grayscaleSeven
        }
    }
    
}
