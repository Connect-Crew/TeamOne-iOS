//
//  ApplyResultView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import DSKit
import UIKit
import RxSwift
import RxCocoa
import Domain
import Core

final class ApplyResultView: UIView {

    let imageViewResult = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .image(dsimage: .complete)
    }

    let labelTitle = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(text: "지원이 완료되었습니다.", typo: .body2, color: .teamOne.grayscaleSeven)
    }

    let labelContent = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.setLabel(text: "결과는 지원 현황 페이지에서\n확인하실 수 있습니다.", typo: .button2, color: .teamOne.grayscaleSeven)
    }

    let okButton = UIButton().then {
        $0.backgroundColor = .teamOne.mainColor
        $0.setButton(text: "확인", typo: .button2, color: .teamOne.white)

        $0.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

    lazy var contentView = UIStackView(arrangedSubviews: [
        makeContentStackView(),
        okButton
    ]).then {
        $0.axis = .vertical
        $0.backgroundColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initSetting()
    }

    func initSetting() {
        layout()
    }

    func layout() {
        addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }

        self.setRound(radius: 8)
        self.clipsToBounds = true
    }

    func makeContentStackView() -> UIStackView {

        return UIStackView(arrangedSubviews: [
            imageViewResult,
            labelTitle,
            labelContent
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 20)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
            $0.spacing = 12
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
