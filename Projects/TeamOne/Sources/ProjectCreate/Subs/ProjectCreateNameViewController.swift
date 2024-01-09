//
//  ProjectCreateNameViewController.swift
//  TeamOne
//
//  Created by 강현준 on 12/2/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit

final class ProjectCreateNameViewController: ViewController {

    let titleLabel = UILabel().then {
        $0.setLabel(text: "프로젝트 이름을 만들어 볼까요?", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let contentLabel = UILabel().then {
        $0.setLabel(text: "최소 2글자 이상, 최대 30자 이하로 입력해주세요.", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let textFieldName = UITextField().then {
        $0.font = .setFont(font: .body3)
        $0.textColor = .teamOne.grayscaleFive
        $0.placeholder = "프로젝트 이름"
    }

    let viewUnderBar = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleFive)
        $0.setRound(radius: 2)
    }

    let labelError = UILabel().then {
        $0.setLabel(text: "* 최소 두 글자 이상 입력해주세요.", typo: .caption2, color: .red)
        $0.isHidden = true
    }

    let labelCounting = UILabel().then {
        $0.setLabel(text: "0/30", typo: .caption2, color: .teamOne.grayscaleFive)
        $0.textAlignment = .right
    }

    let buttonNext = Button_IsEnabled(enabledString: "다음", disabledString: "다음").then {
        $0.setRound(radius: 8)
        $0.isEnabled = false
    }

    lazy var contentView = UIStackView(arrangedSubviews: [
        titleLabel,
        contentLabel,
        textFieldName,
        viewUnderBar,
        makeLabelStackView(),
        UIView()
    ]).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.layoutMargins = UIEdgeInsets(top: 40, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true

        $0.setCustomSpacing(16, after: contentLabel)
    }

    lazy var buttonStackView = UIStackView(arrangedSubviews: [
        buttonNext
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func layout() {
        self.view.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(buttonStackView)

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        buttonNext.snp.makeConstraints {
            $0.height.equalTo(52)
        }

        buttonStackView.adjustForKeyboard(disposeBag: disposeBag)
    }
    
    func bind(output: ProjectCreateMainViewModel.Output) {
        output.projectCreateProps
            .map { $0.title }
            .drive(textFieldName.rx.text)
            .disposed(by: disposeBag)
        
        let textAvailable = output.projectCreateProps
            .map { $0.title }
            .compactMap { $0 }
            .map { $0.count >= 2}
            .asObservable()

        textAvailable
            .bind(to: labelError.rx.isHidden)
            .disposed(by: disposeBag)

        textAvailable
            .bind(to: buttonNext.rx.isEnabled)
            .disposed(by: disposeBag)

        textAvailable
            .withUnretained(self)
            .subscribe(onNext: { view, result in
                if result == true {
                    view.viewUnderBar.backgroundColor = .teamOne.mainColor
                    view.labelCounting.textColor = .teamOne.mainColor
                } else {
                    view.viewUnderBar.backgroundColor = .teamOne.point
                    view.labelCounting.textColor = .teamOne.point
                }
            })
            .disposed(by: disposeBag)
        
        output.projectCreateProps
            .map { $0.title }
            .map { $0?.count }
            .compactMap { $0 }
            .drive(onNext: { [weak self] result in
                self?.labelCounting.text = "\(result)/30"
            })
            .disposed(by: disposeBag)

        textFieldName.rx.text.orEmpty
            .map { String($0.prefix(29)) }
            .subscribe(onNext: { [weak self] text in
                self?.textFieldName.text = text
            })
            .disposed(by: disposeBag)

        labelError.isHidden = true
        labelCounting.textColor = .teamOne.grayscaleFive
        viewUnderBar.backgroundColor = .teamOne.grayscaleFive
    }

    func makeLabelStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelError,
            UIView(),
            labelCounting
        ])
    }
}

