//
//  IntroduceBottomView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/28.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import SnapKit
import Then

final class IntroduceBottomView: UIView {

    let buttonLike = Button_IsLiked(count: 0, typo: .caption1, isLiked: false, likedImage: .heartsolid, unLikedImage: .heartline, likedTextColor: .teamOne.point)

    let buttonApply = Button_IsEnabled(
        enabledString: "지원하기",
        disabledString: "지원이 모두 마감되었습니다."
    ).then {
        $0.setRound(radius: 8)
        $0.setButton(text: "", typo: .button1, color: .black)
        $0.isEnabled = true
    }

    lazy var contentView = UIStackView(arrangedSubviews: [
        buttonLike,
        buttonApply
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 11, left: 24, bottom: 11, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 10
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    func layout() {
        self.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        buttonApply.snp.makeConstraints {
            $0.width.equalTo(253)
            $0.height.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
