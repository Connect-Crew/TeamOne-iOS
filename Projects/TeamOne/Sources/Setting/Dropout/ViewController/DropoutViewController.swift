//
//  DropoutViewController.swift
//  TeamOne
//
//  Created by 강창혁 on 2/7/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import UIKit
import Core
import DSKit
import RxSwift
import RxCocoa
import Then

final class DropoutViewController: ViewController {
    
    private let viewModel: DropoutViewModel
    
    private let mainView = DropoutMainView()
    
    lazy var dropoutSuccessItem = ResultAlertView_Image_Title_Content_Alert(
        image: .complete,
        title: "탈퇴가 완료되었습니다.",
        content: "다음에 다시 만나요.",
        availableCancle: false,
        resultSubject: PublishSubject<Bool>()
    )
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    // MARK: - Inits
    
    init(viewModel: DropoutViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        
        guard let dropoutResult = dropoutSuccessItem.resultSubject else { return }
        let input = DropoutViewModel.Input(
            tapBack: mainView.backButton.rx.tap.asObservable(),
            noProjectCheck: mainView.dropoutReasonView.noProjectCheckBox.rx.tap.asObservable(),
            noUserCheck: mainView.dropoutReasonView.noUserCheckBox.rx.tap.asObservable(),
            noTeamMemberCheck: mainView.dropoutReasonView.noTeamCheckBox.rx.tap.asObservable(),
            noMannerCheck: mainView.dropoutReasonView.noMannerCheckBox.rx.tap.asObservable(),
            newAccountCheck: mainView.dropoutReasonView.newAccountCheckBox.rx.tap.asObservable(),
            etcCheck: mainView.dropoutReasonView.etcCheckBox.rx.tap.asObservable(),
            etcText: mainView.dropoutReasonView.etcReasonTextField.rx.text.orEmpty.asObservable(),
            dropoutResult: dropoutResult
        )
        
        let output = viewModel.transform(input: input)
        
        output.noProjectIsSeleted
            .drive(mainView.dropoutReasonView.noProjectCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        output.noUserIsSeleted
            .drive(mainView.dropoutReasonView.noUserCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        output.noTeamIsSeleted
            .drive(mainView.dropoutReasonView.noTeamCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        output.noMannerIsSeleted
            .drive(mainView.dropoutReasonView.noMannerCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        output.newAccountIsSeleted
            .drive(mainView.dropoutReasonView.newAccountCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        output.etcIsSeleted
            .drive(mainView.dropoutReasonView.etcCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.etcIsSeleted
        output.etcTextFieldIshidden
            .drive(mainView.dropoutReasonView.etcStackView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isEnabled
            .drive(mainView.dropoutButton.rx.isEnabled)
            .disposed(by: disposeBag)
        output.etcDescriptionLabelIshidden
            .drive(mainView.dropoutReasonView.waringDescriptionView.rx.isHidden)
            .disposed(by: disposeBag)
        output.underLineColorChanged
            .drive(onNext: { [weak self] changed in
                if changed {
                    self?.mainView.dropoutReasonView.etcTextFieldUnderLine.backgroundColor = .teamOne.point
                } else {
                    self?.mainView.dropoutReasonView.etcTextFieldUnderLine.backgroundColor = .teamOne.grayscaleSeven
                }
            })
            .disposed(by: disposeBag)
        
        mainView.dropoutButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { this, _ in
                this.presentResultAlertView_Image_Title_Content(source: this, alert: this.dropoutSuccessItem)
            })
            .disposed(by: disposeBag)
        
        
    }
}
