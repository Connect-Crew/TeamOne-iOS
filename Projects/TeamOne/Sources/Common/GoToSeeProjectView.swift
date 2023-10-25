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
        $0.setLabel(text: "프로젝트 구경하러가기 (준비 중)", typo: .body2, color: .teamOne.white)
    }

    let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabel(text: "이번 달에 완성된 프로젝트를 구경하고 \n직접 커피챗을 보내세요!", typo: .caption1, color: .teamOne.white)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()

        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        backgroundColor = .teamOne.mainBlue

        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.leading.equalToSuperview().offset(20)
        }

        addSubview(descriptionLabel)

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(titleLabel)
        }
    }

}
