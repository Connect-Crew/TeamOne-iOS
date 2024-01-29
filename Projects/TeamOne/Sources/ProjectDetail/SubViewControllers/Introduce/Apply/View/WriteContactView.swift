//
//  WriteContactView.swift
//  TeamOne
//
//  Created by 강현준 on 1/24/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import DSKit
import UIKit
import RxSwift
import RxCocoa
import Domain
import Core

final class WriteContactView: View {
    
    private let introduceLabel = UILabel().then {
        $0.setLabel(text: "2. 연락받을 연락처를 알려주세요", typo: .body4, color: .teamOne.grayscaleSeven)
    }

    let textView = TextView_PlaceHolder(frame: .zero, textContainer: nil).then {
        $0.maxTextCount = 1000
        $0.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.placeholder = "전화번호, 카카오톡 아이디 등을 알려주세요. \nex) '카카오톡아이디 teamone1'"
        $0.setRound(radius: 8)
        $0.setFont(typo: .button2)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
        $0.textColor = .black
        $0.placeholderTextColor = .teamOne.grayscaleFive
    }
    
    private let imageViewPrivacyPolicy = UIImageView().then {
        $0.image = .image(dsimage: .warningGray)
    }
    
    private let labelPrivacyPolicy = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabel(text: "원활한 프로젝트 진행을 위한 목적일 뿐, 어떠한 개인정보도 수집되지 않습니다.", typo: .caption2, color: .teamOne.grayscaleFive)
    }
    
    private let imageViewWarnning = UIImageView().then {
        $0.image = .image(dsimage: .warning)
    }
    
    private let labelWarnning = UILabel().then {
        $0.setLabel(text: "연락처를 입력해주세요", typo: .caption2, color: .teamOne.point)
    }

    let cancleButton = UIButton().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.setButton(text: "취소", typo: .button2, color: .teamOne.grayscaleSeven)
    }

    let applyButton = UIButton().then {
        $0.backgroundColor = .teamOne.mainColor
        $0.setButton(text: "지원하기", typo: .button2, color: .teamOne.white)
        $0.isEnabled = false
    }
    
    private lazy var privacyPolicyStackView = UIStackView(arrangedSubviews: [
        imageViewPrivacyPolicy,
        labelPrivacyPolicy
    ]).then {
        $0.spacing = 2
        $0.alignment = .leading
    }
    
    private lazy var warnningStackView = UIStackView(arrangedSubviews: [
        imageViewWarnning,
        labelWarnning
    ]).then {
        $0.spacing = 2
        $0.alignment = .leading
        $0.isHidden = true
    }

    lazy var contentView = UIStackView(arrangedSubviews: [
        makeContentStackView(),
        makeButtonStackView()
    ]).then {
        $0.axis = .vertical
        $0.backgroundColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initSetting()
    }

    func initSetting() {
        layout()
        
        textView.rxTextObservable
            .map { $0.count }
            .withUnretained(self)
            .bind(onNext: { this, cnt in
                if cnt > 0 {
                    this.warnningStackView.isHidden = true
                    this.applyButton.isEnabled = true
                } else {
                    this.warnningStackView.isHidden = false
                    this.applyButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
    }

    func layout() {
        
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
        
        self.setRound(radius: 8)
        self.clipsToBounds = true
        
        
        imageViewWarnning.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        imageViewPrivacyPolicy.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        adjustForKeyboard(disposeBag: disposeBag)
    }

    func makeContentStackView() -> UIStackView {

        textView.snp.makeConstraints {
            $0.height.equalTo(80)
        }

        return UIStackView(arrangedSubviews: [
            introduceLabel,
            textView,
            privacyPolicyStackView,
            warnningStackView
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 20)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
            $0.spacing = 8
        }
    }

    func makeButtonStackView() -> UIStackView {

        [cancleButton, applyButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(48)
            }
        }

        return UIStackView(arrangedSubviews: [
            cancleButton,
            applyButton
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
