//
//  GoToSeeProjectView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Then
import SnapKit

final class GoToSeeProjectView: UIView {

    let titleLabel = UILabel().then {
        $0.setLabel(text: "이번달에 완성된 프로젝트 보러가기 (준비 중)", typo: .body2, color: .teamOne.white)
    }

    let descriptionLabel = UILabel().then {
        $0.setLabel(text: "프로젝트를 구경하고 직접 커피챗을 보내세요!", typo: .caption1, color: .teamOne.white)
    }

    let hyperlinkButton = UIButton().then {
        $0.setButton(text: "커뮤니티 바로가기 >>", typo: .caption1, color: .teamOne.white)
    }

    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {

        backgroundColor = .teamOne.mainBlue

        addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(25)
        }

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        contentView.addSubview(descriptionLabel)

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }

        contentView.addSubview(hyperlinkButton)

        hyperlinkButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }

    }

}
