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
import RxCocoa
import RxSwift

final class LoginView: UIView {
    
    let disposeBag = DisposeBag()
    let kakaoButtonAction = PublishSubject<Void>()
    
    let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .teamOne.grayscaleEight
       
    }
    let titleLabel = UILabel().then {
        $0.setLabel(text: "함께 만들어가는 \n 프로젝트 팀원", typo: .title1, color: .teamOne.grayscaleEight)
    }
    let kakaoButton = UIButton().then {
        $0.setButton(image: .kakaoButton)
    }
    let googleButton = UIButton().then {
        $0.setButton(image: .googleButton)
    }
    
  
    let appleButton = UIButton().then {
        $0.setButton(image: .appleButton)
    }
    let kakaoSignUpButton = UIButton().then {
        $0.setButton(image: .kakaoSignUpButton)
    }
    let buttonStacks = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        layout()
//        kakaoButton.rx.tap
//                    .bind(to: kakaoButtonAction)
//                    .disposed(by: disposeBag)
        
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
        addSubview(titleLabel)
        addSubview(kakaoSignUpButton)
        addSubview(buttonStacks)
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(137)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(176)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(19)
            $0.leading.equalToSuperview().offset(129)
        }
        titleLabel.numberOfLines = 2
        
        kakaoSignUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(53)
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            
        }
        
        kakaoButton.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        
        
        buttonStacks.addArrangedSubview(kakaoButton)
        buttonStacks.addArrangedSubview(googleButton)
        buttonStacks.addArrangedSubview(appleButton)
        buttonStacks.axis = .vertical
        buttonStacks.spacing = 10
        buttonStacks.distribution = .fillEqually
       
        
        buttonStacks.snp.makeConstraints {
            $0.top.equalTo(kakaoSignUpButton.snp.bottom).offset(18)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(45)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-45)
           // $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

