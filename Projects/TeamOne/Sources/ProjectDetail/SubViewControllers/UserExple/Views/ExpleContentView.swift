//
//  ExpleContentView.swift
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

final class ExpleContentView: View {
    
    private let labelTitle = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(text: "내보내는 사유를 알려주세요.", typo: .body2, color: .teamOne.grayscaleSeven)
    }
    
    private let buttonFoulLanguage = Button_CheckBox(
        text: User_ExpleReason.foulLanguage.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let buttonLowParticipation = Button_CheckBox(
        text: User_ExpleReason.lowParticipation.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.contentVerticalAlignment = .top
        $0.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        $0.checkedTextColor = .teamOne.mainColor
        $0.titleLabel?.numberOfLines = 0
    }
    
    private let buttonConflicWithTeamMembers = Button_CheckBox(
        text: User_ExpleReason.conflicWithTeamMembers.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let buttonVoluntaryWithdrawal = Button_CheckBox(
        text: User_ExpleReason.voluntaryWithdrawal.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let buttonInappropriateContent = Button_CheckBox(
        text: User_ExpleReason.inappropriateContent.description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let buttonOther = Button_CheckBox(
        text: User_ExpleReason.other("").description,
        typo: .button2,
        textColor: .teamOne.grayscaleSeven,
        type: .checkBoxBlue
    ).then {
        $0.checkedTextColor = .teamOne.mainColor
    }
    
    private let textFieldOther = UITextField().then {
        $0.isEnabled = false
    }
    
    private let textFieldUnderbar = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleFive)
    }
    
    private let imageViewWainning = UIImageView().then {
        $0.image = .image(dsimage: .warinning)
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
    let expleSelected = PublishRelay<User_ExpleReason>()
    
    /// 선택 상태
    private let selectedReason = BehaviorRelay<[User_ExpleReason]>(value: [])
    // TODO: - 취소, 신고버튼 처리, 폰트변경, 신고가능/불가능 상태 처리
    private lazy var warnningStackView = UIStackView(arrangedSubviews: [
        imageViewWainning,
        labelWarnning,
    ]).then {
        $0.spacing = 5
        $0.isHidden = true
    }
    
    private lazy var otherTextFieldStackView = UIStackView(arrangedSubviews: [
        textFieldOther,
        textFieldUnderbar,
        warnningStackView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    private lazy var otherStackView = UIStackView(arrangedSubviews: [
        buttonOther,
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
        bindButtons()
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
        
        buttonOther.snp.makeConstraints {
            $0.width.equalTo(55)
        }
    }
    
    private func bindButtons() {
        
        cancleButton.rx.tap
            .bind(to: cancleSelected)
            .disposed(by: disposeBag)
        
        let checkboxes = [
            buttonFoulLanguage: User_ExpleReason.foulLanguage,
            buttonLowParticipation: User_ExpleReason.lowParticipation,
            buttonConflicWithTeamMembers: User_ExpleReason.conflicWithTeamMembers,
            buttonVoluntaryWithdrawal: User_ExpleReason.voluntaryWithdrawal,
            buttonInappropriateContent: User_ExpleReason.inappropriateContent
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
                    if case .other = $0 { return true }
                    else { return false }
                }), case .other(let value) = otherReason {
                    return !value.isEmpty
                }
                
                // .other 케이스가 없거나, .other의 연관값이 비어있지 않은 경우
                return true
            }
            .bind(to: isExplable)
            .disposed(by: disposeBag)
        
        isExplable
            .bind(onNext: {
                print("DEBUG: isExplable\($0)")
            })
        
        bindOther()
    }
    
    func bindOther() {
        
        buttonOther.rx.tap
            .withUnretained(self)
            .withLatestFrom(buttonOther.rx.isSelected)
            .map { !$0 }
            .bind(to: buttonOther.rx.isSelected)
            .disposed(by: disposeBag)

        let isSelectedOther = buttonOther.rx.isSelected
        
        let selected = isSelectedOther
            .filter { $0 == true }
        
        let unSelected = isSelectedOther
            .filter { $0 == false }

        unSelected
            .withLatestFrom(selectedReason)
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, reasons in
                
                this.textFieldOther.isEnabled = false
                this.textFieldOther.rx.text.onNext("")
                this.warnningStackView.isHidden = true

                var newReasons = reasons
 
                newReasons.removeAll { reason in
                    if case .other = reason {
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
                
                this.textFieldOther.isEnabled = true
                this.warnningStackView.isHidden = false
                
                var newReasons = reasons
                newReasons.append(.other(""))

                this.selectedReason.accept(newReasons)
            })
            .disposed(by: disposeBag)
        
        textFieldOther.rx.text.orEmpty
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
                    where: { if case .other = $0 { return true } else { return false } }) {
                    
                    reasons[otherIndex] = .other(content)
                }
                
                // 변경된 이유들을 selectedReason에 반영
                this.selectedReason.accept(reasons)

            })
            .disposed(by: disposeBag)
    }
    
    func updateSelect(with reasons: [User_ExpleReason]) {
        
        buttonFoulLanguage.isSelected = reasons.contains(.foulLanguage)
        buttonLowParticipation.isSelected = reasons.contains(.lowParticipation)
        buttonConflicWithTeamMembers.isSelected = reasons.contains(.conflicWithTeamMembers)
        buttonVoluntaryWithdrawal.isSelected = reasons.contains(.voluntaryWithdrawal)
        buttonInappropriateContent.isSelected = reasons.contains(.inappropriateContent)
        
    }
    
    func makeTitleStackView() -> UIStackView {
        
        return UIStackView(arrangedSubviews: [
            labelTitle,
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
        }
    }
    
    func makeContentStackView() -> UIStackView {
        
        return UIStackView(arrangedSubviews: [
            buttonFoulLanguage,
            buttonLowParticipation,
            buttonConflicWithTeamMembers,
            buttonVoluntaryWithdrawal,
            buttonInappropriateContent,
            otherStackView
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
            $0.spacing = 12
        }
    }
    
    func makeButtonStackView() -> UIStackView {
        
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
