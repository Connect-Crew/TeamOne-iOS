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
    
//    let logoImageView = UIImageView().then {
//        $0.backgroundColor = .red
//    }
    
    let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = UIColor.blue // 이미지가 없을 때 보일 배경 색
       
    }
         
    
    let titleLabel = UILabel().then {
        $0.setLabel(text: "함께 만들어가는 \n 프로젝트 팀원", typo: .title2, color: .black)
        
    }
    
    let buttonColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    let kakaoSignUpButton = ReusableButton(buttonTitle: "⚡️카카오로 3초만에 빠르게 회원가입!",bgColor:.clear,textColor: .gray,cornerRadius: 15,width: 271,height: 40,image: UIImage(named: "카카오 회원가입"))
    
    let kakaoButton = ReusableButton(buttonTitle: "카카오로 시작하기",bgColor: #colorLiteral(red: 0.9983025193, green: 0.9065476656, blue: 0, alpha: 1),width: 100,height: 45,image: UIImage(named: "kakao_login_large_wide"))
    let googleButton = ReusableButton(buttonTitle: "Google로 시작하기",bgColor: .clear,textColor: .black,cornerRadius:10,width: 200,height: 45,image: UIImage(named: "구글로그인"))
    let appleButton = ReusableButton(buttonTitle: "Apple 시작하기",bgColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),textColor: .black,cornerRadius:10,width: 100,height: 45,image: UIImage(named: "애플로그인"))
    
    let buttonStacks = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.layer.cornerRadius = logoImageView.bounds.width / 2
        logoImageView.image = UIImage(named: "팀 로고")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(137)
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(55)
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
            $0.top.equalTo(kakaoSignUpButton.snp.bottom).offset(18)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(45)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-45)
        }
    }
        
    
}

