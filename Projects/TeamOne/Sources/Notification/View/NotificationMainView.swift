//
//  NotificationMainView.swift
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

final class NotificationMainView: View {
    
    private let navigation = NotificationNavigationView()
    
    private let buttonChatBot = UIButton().then {
        $0.setButton(image: .chatbot)
        $0.adjustsImageWhenHighlighted = false
    }
    
    init() {
        super.init(frame: .zero)
        
        layout()
        bind()
    }
    
    let chatBotTap = PublishRelay<Void>()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        // navigation
        
        addSubview(navigation)
        
        navigation.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        // chatBot
        
        addSubview(buttonChatBot)
        
        buttonChatBot.snp.makeConstraints {
            $0.width.height.equalTo(65)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
        }
    }
    
    private func bind() {
        buttonChatBot.rx.tap
            .bind(to: chatBotTap)
            .disposed(by: disposeBag)
    }
}
