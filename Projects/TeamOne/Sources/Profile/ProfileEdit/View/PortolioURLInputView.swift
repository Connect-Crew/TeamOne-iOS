//
//  PortolioLinkInputView.swift
//  TeamOne
//
//  Created by 강창혁 on 3/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import Then
import SnapKit
import RxSwift
import RxCocoa

final class PortolioURLInputView: View {
    
    let linkURLTextfield = UITextField().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.setFont(font: .button2),
            .foregroundColor: UIColor.teamOne.grayscaleFive
        ]
        
        var attributedString = NSAttributedString(
            string: "링크 첨부",
            attributes: attributes
        )
        $0.attributedPlaceholder = attributedString
        $0.font = .setFont(font: .caption1)
    }
    
    private let linkAttachButton = UIButton().then {
        $0.setButton(image: .attachFile)
    }
    
    private lazy var horizonalDivider = UIView().then {
        $0.setDivider(height: 1, width: self.frame.width, color: .mainColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureLinkAttachButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(linkURLTextfield)
        linkURLTextfield.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(8)
        }
        
        addSubview(linkAttachButton)
        linkAttachButton.snp.makeConstraints {
            $0.leading.equalTo(linkURLTextfield.snp.trailing).offset(8)
            $0.centerY.equalTo(linkURLTextfield)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }
        addSubview(horizonalDivider)
        horizonalDivider.snp.makeConstraints {
            $0.top.equalTo(linkURLTextfield.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6)
        }
    }
    
    private func configureLinkAttachButton() {
        linkAttachButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                if let clipBoardString = UIPasteboard.general.string {
                    this.linkURLTextfield.text = clipBoardString
                }
            }
            .disposed(by: disposeBag)
    }
}
