//
//  NicknameView.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import DSKit
import SnapKit

final class NickNameView: UIView {
    
    // let disposeBag = DisposeBag()
    let nicknameSetLabel = UILabel().then {
        $0.setLabel(text: "닉네임을 설정해주세요.", typo: .title1, color: .teamOne.grayscaleEight)
    }
    
    let explainLabel = UILabel().then {
        $0.setLabel(text: "팀원에서 사용할 닉네임을 만들어주세요.\n건강한 프로젝트 모임을 만들어 나가요!", typo: .body3, color: .teamOne.grayscaleFive)
    }
    
    let nicknameLabel = UILabel().then {
        $0.setLabel(text: "닉네임", typo: .body1, color: .teamOne.grayscaleEight)
    }
    
    let textView = UIView().then {
        $0.backgroundColor = .clear
        
    }
    
    let textField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요."
        $0.borderStyle = .none
    }
    
    let underline = UIView().then {
        $0.backgroundColor = .blue
    }
    
   // let deleteButton = ReusableButton(buttonTitle:"",bgColor: .clear,width: 24,height: 24,image: UIImage(named: "Delete 1"))
    let buttonColor = #colorLiteral(red: 0.9333333333, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
    
    let nextButton = ReusableButton(buttonTitle: "다음",bgColor: #colorLiteral(red: 0.9333333333, green: 0.3019607843, blue: 0.3019607843, alpha: 1),textColor: .white,cornerRadius:10,width: 340,height:52)
    
    let deleteButton = UIButton().then {
        $0.setButton(image: .cancelButton)
    }
    
    
    let loginLabel = UILabel().then {
        $0.setLabel(text: "올바른 비밀번호 입력하세요", typo: .caption2, color: .teamOne.point)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(nicknameSetLabel)
        nicknameSetLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(119)
            $0.leading.equalToSuperview().offset(40)
        }
        addSubview(explainLabel)
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameSetLabel.snp.bottom).offset(10)
            $0.leading.equalTo(nicknameSetLabel.snp.leading)
        }
        explainLabel.numberOfLines = 2
        
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(explainLabel.snp.leading)
            $0.top.equalTo(explainLabel.snp.bottom).offset(30)
        }
        
        addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nicknameLabel.snp.leading)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 50))
        }
        
        textView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        textView.addSubview(underline)
        underline.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        textView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.top).offset(5)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(24)
        }
        //        titleLabel.numberOfLines = 3
        //
        addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            //  $0.top.equalTo(textView.snp.bottom).offset(167)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(50)
        }
        
        addSubview(loginLabel)
        loginLabel.snp.makeConstraints {
            $0.leading.equalTo(textView.snp.leading)
            $0.top.equalTo(textView.snp.bottom).offset(5)
        }
    }
}

