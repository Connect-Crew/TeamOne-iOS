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

final class ChatMainView: UIView {
    
    let awaitContentLabel = UILabel().then {
        $0.setLabel(text: "페이지 준비중입니다.", typo: .body3, color: .teamOne.grayscaleFive)
    }
    
    let chatInputView = ChatInputBottomView()
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.backgroundColor = .teamOne.background
        
        layoutAwaitContent()
        layoutChatInputView()
    }
    
    func layoutAwaitContent() {
        self.addSubview(awaitContentLabel)
        
        awaitContentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func layoutChatInputView() {
        self.addSubview(chatInputView)
        
        chatInputView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}
