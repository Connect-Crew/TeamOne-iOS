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
        $0.image = .image(dsimage: .AppIcon)
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(150)
        }
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(
            text: "함께 만들어가는\n프로젝트, 팀원",
            typo: .title1,
            color: .teamOne.grayscaleEight)
        $0.numberOfLines = 0
    }

    private let introduceImageView = UIImageView().then {
        $0.image = .image(dsimage: .kakaoLoginExplain)
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

    lazy var logoStackView = UIStackView(arrangedSubviews: [
        UIView(),
        logoImageView,
        titleLabel
    ]).then {
            $0.spacing = 30
            $0.axis = .vertical
            $0.alignment = .center
        }

    lazy var buttonStackView = UIStackView(
        arrangedSubviews: [
            introduceImageView, kakaoButton, googleButton, appleButton
        ]).then {
            $0.distribution = .fill
            $0.spacing = 13
            $0.axis = .vertical
            $0.alignment = .center
        }

    lazy var verticalStackView = UIStackView(arrangedSubviews: [
        UIView(),
        logoStackView,
        buttonStackView,
        UIView()
    ]).then {
        $0.axis = .vertical
        $0.setCustomSpacing(56, after: logoStackView)
    }

    lazy var contentView = UIStackView(arrangedSubviews: [
        verticalStackView
    ]).then {
        $0.axis = .horizontal
        $0.alignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
