//
//  SplashMainView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/06.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

import DSKit

final class SplashMainView: UIView {

    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
        $0.image = .image(dsimage: .logo)
    }

    private let titleLabel = UILabel().then {
        $0.setLabel(text: "TEAM no.1", typo: .largeTitle, color: .white)
        $0.textAlignment = .center
    }

    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {

        self.backgroundColor = .teamOne.mainColor

        addSubview(logoImageView)

        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }

        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom)
            $0.centerX.equalTo(logoImageView)
        }
    }
}
