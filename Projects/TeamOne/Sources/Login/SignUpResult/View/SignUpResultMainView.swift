//
//  SignUpResultMainView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core

final class SignUpResultMainView: View {

    private let imageViewLogo = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
        $0.image = .image(dsimage: .logo)
    }

    private let labelSignUpComplete = UILabel().then {
        $0.setLabel(text: "회원가입 완료!", typo: .body2, color: .teamOne.grayscaleFive)
        $0.textAlignment = .center
    }

    private let labelContent = UILabel().then {
        $0.setLabel(text: "지금 당장\n빛나는 아이디어를 함께할\n팀원들을 모집해보세요!", typo: .title1, color: .teamOne.grayscaleEight)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    let buttonStart = UIButton().then {
        $0.setRound(radius: 8)
        $0.setButton(text: "시작하기", typo: .button1, color: .white)
        $0.backgroundColor = UIColor.teamOne.mainColor
    }

    private lazy var contentView = UIStackView(arrangedSubviews: [ createLogoCompleteStackView(), labelContent]).then {
        $0.axis = .vertical
        $0.spacing = 50
        $0.distribution = .equalCentering
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
            $0.center.equalToSuperview()
        }

        addSubview(buttonStart)

        buttonStart.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(49)
            $0.height.equalTo(52)
        }
    }

    private func createLogoCompleteStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [imageViewLogo, labelSignUpComplete]).then {
            $0.axis = .vertical
            $0.spacing = 18
            $0.alignment = .fill
        }

        return stackView
    }
}
