//
//  NotificationViewController.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit

final class NotificationViewController: ViewController {
    
    lazy var feedbackItem = AlertView_Title_TextView_Item(
        title: "팀원(TEAM no.1)에게 바랍니다!",
        placeHolder: "팀원(TEAM no.1)을 이용하시며 있어 좋을 것 같은 기능들, 불편한 점들을 알려주세요! (최대 1,000자)",
        okButtonTitle: "전송하기",
        maxTextCount: 1000,
        callBack: { [weak self] bool, content in
            
            if bool {
                self?.didFeedbackSendTap.accept(content)
            }
        }
    )
    
    lazy var feedbackSuccessItem = ResultAlertView_Image_Title_Content_Alert(
        image: .complete,
        title: "의견이 전송되었습니다.",
        content: "여러분의 소중한 의견 감사드립니다 🙏",
        availableCancle: false
    )
    
    private let viewModel: NotificationViewModel
    
    private let mainView = NotificationMainView()
    
    private let didFeedbackSendTap = PublishRelay<String>()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Inits
    
    init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = NotificationViewModel.Input(
            didFeedbackSendTap: didFeedbackSendTap
        )
        
        let output = viewModel.transform(input: input)
            
        bindFeedback(output: output)
    }
    
    private func bindFeedback(output: NotificationViewModel.Output) {
        
        mainView.chatBotTap
            .withUnretained(self)
            .bind(onNext: { this, _ in
                this.presentAlert_Title_TextView(source: this, alert: this.feedbackItem)
            })
            .disposed(by: disposeBag)
        
        output.feedbackSuccess
            .withUnretained(self)
            .emit(onNext: { this, _ in
                this.presentResultAlertView_Image_Title_Content(source: this, alert: this.feedbackSuccessItem)
            })
            .disposed(by: disposeBag)
    }
}

