//
//  AlertView+Title+TextView.swift
//  DSKit
//
//  Created by 강현준 on 1/3/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core

public final class AlertView_Title_TextView: UIViewController {
    
    var placeHolder: String
    
    var okButtonTitle: String
    
    var callBack: ((Bool, String) -> ())?

    public let labelTitle = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(text: "", typo: .body2, color: .teamOne.grayscaleSeven)
    }

    public let textView = TextView_PlaceHolder(frame: .zero, textContainer: nil).then {
        $0.maxTextCount = 100
        $0.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.placeholder = ""
        $0.setRound(radius: 8)
        $0.setFont(typo: .caption1)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
    }

    public let cancleButton = UIButton().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.setButton(text: "취소", typo: .button2, color: .teamOne.grayscaleSeven)
    }

    public let okButton = UIButton().then {
        $0.backgroundColor = .teamOne.mainColor
        $0.setButton(text: "지원하기", typo: .button2, color: .teamOne.white)
    }

    lazy var contentView = UIStackView(arrangedSubviews: [
        makeContentStackView(),
        makeButtonStackView()
    ]).then {
        $0.axis = .vertical
        $0.backgroundColor = .white
    }

    public init(
        placeHolder: String,
        okButtonTitle: String,
        callBack: ((Bool, String) -> ())?
    ) {
        self.placeHolder = placeHolder
        self.okButtonTitle = okButtonTitle
        self.callBack = callBack
        
        super.init(nibName: nil, bundle: nil)

        initSetting()
    }

    func initSetting() {
        layout()
        addtarget()
    }

    func layout() {
        
        self.view.backgroundColor = .clear
        
        self.view.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }

        self.contentView.setRound(radius: 8)
        self.contentView.clipsToBounds = true
            
        self.textView.placeholder = placeHolder
        self.okButton.setTitle(okButtonTitle, for: .normal)
    }
    
    func addtarget() {
        self.okButton.addTarget(self, action: okAction, for: .touchUpInside)
        self.cancleButton.addTarget(self, action: cancleAction, for: .touchUpInside)
    }
    
    @objc func okAction() {
        callBack?(true, textView.rxText.)
    }
    
    @objc func cancleAction() {
        
    }

    func makeContentStackView() -> UIStackView {

        textView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(160)
        }

        return UIStackView(arrangedSubviews: [
            labelTitle,
            textView
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 20)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
            $0.spacing = 8
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
