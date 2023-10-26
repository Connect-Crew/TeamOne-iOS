//
//  LoginView.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import DSKit
import SnapKit

final class LoginView: UIView {
    
    let logoImageView = UIImageView().then {
      
        
        $0.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
    }
    
    let titleLabel = UILabel().then {
        $0.setLabel(text: "함께 만들어가는 \n 프로젝트 팀원", typo: .title2, color: .black)
        
    }
    
    let buttonColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    let kakaoSignUpButton = ReusableButton(buttonTitle: "⚡️카카오로 3초만에 빠르게 회원가입!",bgColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), textColor: .gray,cornerRadius: 15,width: 259,height: 27)
   
    let kakaoButton = ReusableButton(buttonTitle: "카카오로 시작하기",bgColor: .yellow,textColor: .black,cornerRadius:10,width: 307,height: 57)
    let googleButton = ReusableButton(buttonTitle: "Google로 시작하기",bgColor:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),textColor: .black,cornerRadius:10,width: 307,height: 57)
    let appleButton = ReusableButton(buttonTitle: "Apple 시작하기",bgColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),textColor: .black,cornerRadius:10,width: 307,height: 57)
    
    let buttonStacks = UIStackView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(130)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(176)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(19)
            $0.leading.equalToSuperview().offset(129)
        }
        titleLabel.numberOfLines = 2
        
        addSubview(kakaoSignUpButton)
        kakaoSignUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(53)
            $0.top.equalTo(titleLabel.snp.bottom).offset(135)
            $0.centerX.equalToSuperview()
            
        }
        buttonStacks.addArrangedSubview(kakaoButton)
        buttonStacks.addArrangedSubview(googleButton)
        buttonStacks.addArrangedSubview(appleButton)
        buttonStacks.axis = .vertical
        buttonStacks.spacing = 10
        buttonStacks.distribution = .fillEqually
        addSubview(buttonStacks)
        buttonStacks.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(29)
            $0.top.equalTo(kakaoSignUpButton.snp.bottom).offset(15)
        }
        
    }
     
    
    print("로그인 브랜치 생성 테스트")
    
    
}

