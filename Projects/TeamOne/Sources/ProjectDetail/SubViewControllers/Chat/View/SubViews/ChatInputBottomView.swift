//
//  ChatInputBottomView.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Core
import DSKit

final class ChatInputBottomView: UIView {
    
    let inputTextView = TextView_PlaceHolder().then {
        $0.placeholder = "메시지를 입력해주세요."
        $0.placeholderTextColor = .teamOne.grayscaleFive
        $0.setRound(radius: 8)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
        $0.setFont(typo: .button2)
        $0.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
    }
    
    let sendButton = UIButton().then {
        $0.setButton(image: .send)
        $0.backgroundColor = .teamOne.grayscaleTwo
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        UIView(),
        sendButton,
        UIView()
    ]).then {
        $0.axis = .vertical
    }
    
    private lazy var contentView = UIStackView(arrangedSubviews: [
        inputTextView,
        buttonStackView
    ]).then {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        $0.spacing = 8
    }
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        layoutContentView()
        layoutInputTextView()
        layoutSendButton()
    }
    
    func layoutContentView() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func layoutInputTextView() {
        inputTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(40)
        }
    }
    
    func layoutSendButton() {
        sendButton.snp.makeConstraints {
            $0.height.width.equalTo(36)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sendButton.setRoundCircle()
    }
}
