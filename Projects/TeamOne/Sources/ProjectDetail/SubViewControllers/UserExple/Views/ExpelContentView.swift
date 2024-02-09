//
//  ExpelContentView.swift
//  TeamOne
//
//  Created by 강현준 on 1/12/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import SnapKit
import DSKit
import Domain

final class ExpelContentView: View {
    
    private let labelTitle = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(text: "내보내는 사유를 알려주세요.", typo: .body2, color: .teamOne.grayscaleSeven)
    }
    
    private let buttonAbuse = Button_CheckBox(
        text: User_ExpelReason.abuse.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let buttonBadParticipation = Button_CheckBox(
        text: User_ExpelReason.bad_Participation.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.contentVerticalAlignment = .top
        $0.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        $0.checkedTextColor = .teamOne.mainColor
        $0.titleLabel?.numberOfLines = 0
    }
    
    private let buttonDissension = Button_CheckBox(
        text: User_ExpelReason.dissension.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let buttonGivenUp = Button_CheckBox(
        text: User_ExpelReason.givenUp.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let buttonObsecenity = Button_CheckBox(
        text: User_ExpelReason.obscenity.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let buttonEtc = Button_CheckBox(
        text: User_ExpelReason.etc("").description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let textFieldEtc = UITextField().then {
        $0.font = .setFont(font: .button2)
        $0.textColor = .teamOne.grayscaleFive
        $0.isEnabled = false
    }
    
    private let textFieldUnderbar = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleFive)
    }
    
    private let imageViewWainning = UIImageView().then {
        $0.image = .image(dsimage: .warning)
    }
    
    private let labelWarnning = UILabel().then {
        $0.setLabel(text: "내용을 입력해주세요", typo: .caption2, color: .teamOne.point)
    }
    
    private let cancleButton = UIButton().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.setButton(text: "취소", typo: .button2, color: .teamOne.grayscaleSeven)
    }
    
    private let okButton = UIButton().then {
        $0.backgroundColor = .teamOne.mainColor
        $0.setButton(text: "내보내기", typo: .button2, color: .teamOne.white)
    }
    
    /// 선택 결과
    let isExplable = BehaviorRelay(value: false)
    let cancleSelected = PublishRelay<Void>()
    let expelSelected = PublishRelay<[User_ExpelReason]>()
    
    /// 선택 상태
    private let selectedReason = BehaviorRelay<[User_ExpelReason]>(value: [])
        
    private lazy var warnningStackView = UIStackView(arrangedSubviews: [
        imageViewWainning,
        labelWarnning
    ]).then {
        $0.spacing = 5
        $0.isHidden = true
    }
    
    private lazy var otherTextFieldStackView = UIStackView(arrangedSubviews: [
        textFieldEtc,
        textFieldUnderbar,
        warnningStackView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    private lazy var otherStackView = UIStackView(arrangedSubviews: [
        buttonEtc,
        otherTextFieldStackView
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .top
        $0.distribution = .fill
    }
    
    private lazy var contentView = UIStackView(arrangedSubviews: [
        makeTitleStackView(),
        makeContentStackView(),
        makeButtonStackView()
    ]).then {
        $0.axis = .vertical
        $0.backgroundColor = .white
    }
    
    public init() {
        
        super.init(frame: .zero)
        
        initSetting()
        bind()
    }
    
    func initSetting() {
        layout()
    }
    
    private func layout() {
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.setRound(radius: 8)
        self.clipsToBounds = true
        
        imageViewWainning.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        buttonEtc.snp.makeConstraints {
            $0.width.equalTo(55)
        }
    }
    
    private func bind() {
        bindButtons()
        bindOther()
        bindOkButton()
        bindCancleButton()
    }
    
    private func bindButtons() {
        
        cancleButton.rx.tap
            .bind(to: cancleSelected)
            .disposed(by: disposeBag)
        
        let checkboxes = [
            buttonAbuse: User_ExpelReason.abuse,
            buttonBadParticipation: User_ExpelReason.bad_Participation,
            buttonDissension: User_ExpelReason.dissension,
            buttonGivenUp: User_ExpelReason.givenUp,
            buttonObsecenity: User_ExpelReason.obscenity
        ]
        
        for (button, reason) in checkboxes {
            button.rx.tap
                .withLatestFrom(button.rx.isSelected)
                .withUnretained(self)
                .subscribe(onNext: { this, isSelected in
                  
                    var reasons = this.selectedReason.value
                    
                    if isSelected {
                        reasons.removeAll { $0 == reason }
                    } else {
                        reasons.append(reason)
                    }
                    
                    this.selectedReason.accept(reasons)
                })
                .disposed(by: disposeBag)
            
            selectedReason
                .asSignal(onErrorJustReturn: [])
                .withUnretained(self)
                .emit(onNext: { this, array in
                    this.updateSelect(with: array)
                })
                .disposed(by: disposeBag)
        }
        
        // 목록이 선택 되었는지, other케이스가 있는 경우 신고 내용이 포함되어있는지 검증
        selectedReason
            .map { reasons -> Bool in
                // 배열에 요소가 하나라도 있는지 확인
                guard !reasons.isEmpty else { return false }

                // .other 케이스가 있는지 확인하고, 연관값이 비어있는지 검사
                if let otherReason = reasons.first(where: {
                    if case .etc = $0 { return true }
                    else { return false }
                }), case .etc(let value) = otherReason {
                    return !value.isEmpty
                }
                
                // .other 케이스가 없거나, .other의 연관값이 비어있지 않은 경우
                return true
            }
            .bind(to: isExplable)
            .disposed(by: disposeBag)
    }
    
    private func bindOther() {
        
        buttonEtc.rx.tap
            .withUnretained(self)
            .withLatestFrom(buttonEtc.rx.isSelected)
            .map { !$0 }
            .bind(to: buttonEtc.rx.isSelected)
            .disposed(by: disposeBag)

        let isSelectedOther = buttonEtc.rx.isSelected
        
        let selected = isSelectedOther
            .filter { $0 == true }
        
        let unSelected = isSelectedOther
            .filter { $0 == false }

        unSelected
            .withLatestFrom(selectedReason)
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, reasons in
                
                this.textFieldEtc.isEnabled = false
                this.textFieldEtc.rx.text.onNext("")
                this.warnningStackView.isHidden = true

                var newReasons = reasons
 
                newReasons.removeAll { reason in
                    if case .etc = reason {
                        return true
                    }
                    return false
                }
                
                this.selectedReason.accept(newReasons)
            })
            .disposed(by: disposeBag)
        
        selected
            .withLatestFrom(selectedReason)
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, reasons in
                
                this.textFieldEtc.isEnabled = true
                this.warnningStackView.isHidden = false
                
                var newReasons = reasons
                newReasons.append(.etc(""))

                this.selectedReason.accept(newReasons)
            })
            .disposed(by: disposeBag)
        
        textFieldEtc.rx.text.orEmpty
            .skip(1)
            .asSignal(onErrorJustReturn: "")
            .withUnretained(self)
            .emit(onNext: { this, content in
                
                if content.isEmpty {
                    this.warnningStackView.isHidden = false
                } else {
                    this.warnningStackView.isHidden = true
                }
                
                // 현재 선택된 이유들 가져오기
                var reasons = this.selectedReason.value 
                
                // .other 케이스를 찾아서 업데이트
                if let otherIndex = reasons.firstIndex(
                    where: { if case .etc = $0 { return true } else { return false } }) {
                    
                    reasons[otherIndex] = .etc(content)
                }
                
                // 변경된 이유들을 selectedReason에 반영
                this.selectedReason.accept(reasons)

            })
            .disposed(by: disposeBag)
    }
    
    private func bindOkButton() {
        isExplable
            .bind(to: okButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .withLatestFrom(selectedReason)
            .bind(to: expelSelected)
            .disposed(by: disposeBag)
    }
    
    private func bindCancleButton() {
        cancleButton.rx.tap
            .bind(to: cancleSelected)
            .disposed(by: disposeBag)
    }
    
    func updateSelect(with reasons: [User_ExpelReason]) {
        
        buttonAbuse.isSelected = reasons.contains(.abuse)
        buttonBadParticipation.isSelected = reasons.contains(.bad_Participation)
        buttonDissension.isSelected = reasons.contains(.dissension)
        buttonGivenUp.isSelected = reasons.contains(.givenUp)
        buttonObsecenity.isSelected = reasons.contains(.obscenity)
        
    }
    
    private func makeTitleStackView() -> UIStackView {
        
        return UIStackView(arrangedSubviews: [
            labelTitle
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
        }
    }
    
    private func makeContentStackView() -> UIStackView {
        
        return UIStackView(arrangedSubviews: [
            buttonAbuse,
            buttonBadParticipation,
            buttonDissension,
            buttonGivenUp,
            buttonObsecenity,
            otherStackView
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
            $0.spacing = 12
        }
    }
    
    private func makeButtonStackView() -> UIStackView {
        
        [cancleButton, okButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(48)
            }
        }
        
        return UIStackView(arrangedSubviews: [
            cancleButton,
            okButton
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
