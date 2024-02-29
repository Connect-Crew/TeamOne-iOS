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

final class ReportMainView: UIView {
    
    private let mainViewContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let reportTitle = UILabel().then {
        $0.setLabel(text: "김감자 님의 신고 사유를 알려주세요.", typo: .body2, color: .grayscaleEight)
        $0.textAlignment = .center
    }
    
    let reportStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    let abusiveLanguage = Button_CheckBox(text: "욕설 / 비하발언", typo: .button2, textColor: .grayscaleSeven)
    let lowParticipation = Button_CheckBox(text: "참여율 저조\n(응답률, 접속률, 투표 진행 등)", typo: .button2, textColor: .grayscaleSeven).then {
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.lineBreakMode = .byWordWrapping
    }
    let spamming = Button_CheckBox(text: "프로젝트 생성, 채팅 등 도배", typo: .button2, textColor: .grayscaleSeven)
    let promotionalContent = Button_CheckBox(text: "홍보성 컨텐츠", typo: .button2, textColor: .grayscaleSeven)
    let inappropriateNicknameOrProfilePhoto = Button_CheckBox(text: "부적절한 닉네임 / 프로필 사진", typo: .button2, textColor: .grayscaleSeven)
    let privacyInvasion = Button_CheckBox(text: "개인 사생활 침해", typo: .button2, textColor: .grayscaleSeven)
    let adultContent = Button_CheckBox(text: "19+ 음란성, 만남 유도", typo: .button2, textColor: .grayscaleSeven)
    let other = Button_CheckBox(text: "기타", typo: .button2, textColor: .grayscaleSeven)
    
    let errorView = UIView()
    let errorImageView = UIImageView()
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
        
        [
            abusiveLanguage,
            lowParticipation,
            spamming,
            promotionalContent,
            inappropriateNicknameOrProfilePhoto,
            privacyInvasion,
            adultContent,
            other,
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
