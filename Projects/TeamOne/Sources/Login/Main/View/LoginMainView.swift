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

final class LoginMainView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
        $0.image = .image(dsimage: .logo)
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(
            text: "함께 만들어가는",
            typo: .title1,
            color: .teamOne.grayscaleEight)
    }

    private let titleLabelTwo = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(
            text: "프로젝트, 팀원",
            typo: .title1,
            color: .teamOne.grayscaleEight)
    }

    private let introduceImageView = UIImageView().then {
        $0.image = .image(dsimage: .kakaoLoginExplain)
    }

    private let buttonStackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 13
        $0.axis = .vertical
        $0.alignment = .top
    }

    let kakaoButton = UIButton().then {
        $0.setButton(image: .kakaoLoginButtonBG)
    }

    let googleButton = UIButton().then {
        $0.setButton(image: .googleLoginButtonBG)
    }
  
    let appleButton = UIButton().then {
        $0.setButton(image: .appleLoginButtonBG)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(titleLabelTwo)
        addSubview(introduceImageView)
        addSubview(buttonStackView)
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(137)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(176)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview()
        }

        titleLabelTwo.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        introduceImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabelTwo.snp.bottom
            ).offset(56)
            $0.centerX.equalToSuperview()
        }

        let buttonArray = [kakaoButton, googleButton, appleButton, UIView()]

        buttonStackView.addArrangeSubViews(views: buttonArray)

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(introduceImageView.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
