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
import RxSwift
import RxCocoa

final class ChatInputBottomView: UIView {
    
    private let textViewMaxHeight: CGFloat = 112
    private let disposeBag = DisposeBag()
    
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
    
//    private lazy var contentView = UIStackView(arrangedSubviews: [
//        inputTextView,
//        sendButton
//    ]).then {
//        $0.isLayoutMarginsRelativeArrangement = true
//        $0.layoutMargins = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
//        $0.spacing = 8
//        $0.alignment = .bottom
//    }
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
//        layoutContentView()
        layoutInputTextView()
        layoutSendButton()
    }
    
//    func layoutContentView() {
//        addSubview(contentView)
//        
//        contentView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
    
    func layoutInputTextView() {
        
        addSubview(inputTextView)
        
        inputTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.height.lessThanOrEqualTo(textViewMaxHeight)
        }
        
        inputTextView.isScrollEnabled = false
        
        inputTextView.rx.didChange
            .withUnretained(self)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { this, _ in
                
                let size = CGSize(width: this.inputTextView.frame.width, height: .infinity)
                let estimatedSize = this.inputTextView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height >= this.textViewMaxHeight
                
                if isMaxHeight == this.inputTextView.isScrollEnabled { return }
                
                this.inputTextView.isScrollEnabled = isMaxHeight
                this.inputTextView.reloadInputViews()
            })
            .disposed(by: disposeBag)
    }
    
    func layoutSendButton() {
        addSubview(sendButton)
        
        sendButton.snp.makeConstraints {
            $0.leading.equalTo(inputTextView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(40)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(12)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sendButton.setRoundCircle()
    }
}
