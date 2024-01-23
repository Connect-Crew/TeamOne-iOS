//
//  WriteApplicationView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import DSKit
import UIKit
import RxSwift
import RxCocoa
import Domain
import Core

final class WriteApplicationView: View {

    let labelPart = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(text: "[]에 지원합니다", typo: .body2, color: .teamOne.grayscaleSeven)
    }

    let textView = TextView_PlaceHolder(frame: .zero, textContainer: nil).then {
        $0.maxTextCount = 1000
        $0.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.placeholder = "지원 이유 및 강점 (최대 1,000자 입력 가능합니다.)"
        $0.setRound(radius: 8)
        $0.setFont(typo: .button2)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
        $0.textColor = .black
        $0.placeholderTextColor = .teamOne.grayscaleFive
    }
    
    private let imageViewWarnning = UIImageView().then {
        $0.image = .image(dsimage: .warinning)
    }
    
    private let labelWarnning = UILabel().then {
        $0.setLabel(text: "내용을 입력해주세요", typo: .caption2, color: .teamOne.point)
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
    }

    func setContent(status: RecruitStatus) {
        self.labelPart.text = "[ \(status.part) ]에 지원합니다."
    }

    func makeContentStackView() -> UIStackView {

        textView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(160)
        }

        return UIStackView(arrangedSubviews: [
            labelPart,
            textView,
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
