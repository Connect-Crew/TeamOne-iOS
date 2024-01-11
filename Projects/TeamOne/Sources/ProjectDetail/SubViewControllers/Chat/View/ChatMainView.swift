//
//  ChatMainView.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit
import RxKeyboard

final class ChatMainView: View {
    
    private let awaitContentLabel = UILabel().then {
        $0.setLabel(text: "페이지 준비중입니다.", typo: .body3, color: .teamOne.grayscaleFive)
    }
    
    private let chatInputView = ChatInputBottomView()
    
    init() {
        super.init(frame: .zero)
        
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.backgroundColor = .teamOne.background
        
        layoutAwaitContent()
        layoutChatInputView()
    }
    
    private func layoutAwaitContent() {
        self.addSubview(awaitContentLabel)
        
        awaitContentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func layoutChatInputView() {
        self.addSubview(chatInputView)
        
        chatInputView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func bind() {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] height in
                self?.updateChatInputViewLayout(height: height)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateChatInputViewLayout(height: CGFloat) {
        if height == 0 {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self else { return }
                self.chatInputView.snp.remakeConstraints {
                    $0.bottom.leading.trailing.equalToSuperview()
                }
                
                layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                self.chatInputView.snp.remakeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.bottom.equalToSuperview().inset(height)
                }
                layoutIfNeeded()
            }
        }
    }
}
