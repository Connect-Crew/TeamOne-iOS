//
//  DropoutHeaderView.swift
//  TeamOne
//
//  Created by 강창혁 on 2/7/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

final class DropoutHeaderView: UIView {
    
    let headerTitleLabel = UILabel().then {
        $0.setLabel(
            text: "김감자 님! 탈퇴하고 싶으신가요?\n이유를 알려주세요, 너무 아쉬워요.",
            typo: .body2,
            color: .teamOne.grayscaleEight
        )
        $0.numberOfLines = 0
    }
    
    let headerSubTitleLabel = UILabel().then {
        let subtitleText = "계정을 삭제하면 생성한 프로젝트 게시글 외의 모든 게시글,\n관심 프로젝트, 꿀단지 등 모든 활동 정보가 삭제됩니다.\n탈퇴 후 7일간 다시 가입할 수 없어요!"
        let subtitleAttributedText = NSMutableAttributedString(
            string: subtitleText
        )
        subtitleAttributedText.addAttribute(
            .font,
            value: UIFont.setFont(font: .button2),
            range: (subtitleText as NSString).range(of: subtitleText)
        )
        subtitleAttributedText.addAttribute(
            .foregroundColor,
            value: UIColor.teamOne.grayscaleEight,
            range: (subtitleText as NSString).range(of: "계정을 삭제하면 생성한 프로젝트 게시글 외의 모든 게시글,\n관심 프로젝트, 꿀단지 등 모든 활동 정보가 삭제됩니다.")
        )
        subtitleAttributedText.addAttribute(
            .foregroundColor,
            value: UIColor.teamOne.point,
            range: (subtitleText as NSString).range(of: "탈퇴 후 7일간 다시 가입할 수 없어요!")
        )
        $0.attributedText = subtitleAttributedText
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {
        addSubview(headerTitleLabel)
        addSubview(headerSubTitleLabel)
        
        headerTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
        }
        
        headerSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(9)
        }
    }
    
}
