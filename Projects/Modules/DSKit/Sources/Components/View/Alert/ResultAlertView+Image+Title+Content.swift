//
//  ResultAlertView+Image+Title+Content.swift
//  DSKit
//
//  Created by 강현준 on 12/3/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Core
import SnapKit
import Then

public extension UIViewController {
    func presentResultAlertView_Image_Title_Content(source: UIViewController?, alert: ResultAlertView_Image_Title_Content_Alert) {

        let viewController = ResultAlertView_Image_Title_ContentVC(alert: alert)

        viewController.modalPresentationStyle = .overFullScreen

        source?.present(viewController, animated: false)
    }
}

public struct ResultAlertView_Image_Title_Content_Alert {
    public let image: ResultAlertView_Image
    public let title: String
    public let content: String
    public let availableCancle: Bool
    public let resultSubject: PublishSubject<Bool>

    public init(image: ResultAlertView_Image, title: String, content: String, availableCancle: Bool, resultSubject: PublishSubject<Bool>) {
        self.image = image
        self.title = title
        self.content = content
        self.availableCancle = availableCancle
        self.resultSubject = resultSubject
    }
}

public enum ResultAlertView_Image {
    case warnning
    case write
}

open class ResultAlertView_Image_Title_ContentVC: ViewController {

    private let buttonBackground = UIButton().then {
        $0.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.7)
    }

    public let imageViewResult = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }

    public let labelTitle = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(text: "", typo: .body2, color: .teamOne.grayscaleSeven)
    }

    public let labelContent = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.setLabel(text: "", typo: .button2, color: .teamOne.grayscaleSeven)
    }

    public let okButton = UIButton().then {
        $0.backgroundColor = .teamOne.mainColor
        $0.setButton(text: "확인", typo: .button2, color: .teamOne.white)

        $0.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

    public let cancleButton = UIButton().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.setButton(text: "취소", typo: .button2, color: .teamOne.grayscaleSeven)

        $0.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

    private lazy var contentView = UIStackView(arrangedSubviews: [
        makeContentStackView(),
        markButtonStackView()
    ]).then {
        $0.axis = .vertical
        $0.backgroundColor = .white
    }

    public init(alert: ResultAlertView_Image_Title_Content_Alert) {
        super.init(nibName: nil, bundle: nil)

        initSetting()
        self.bind(alert)
    }

    private func bind(_ alert: ResultAlertView_Image_Title_Content_Alert) {

        switch alert.image {
        case .warnning:
            self.imageViewResult.image = .image(dsimage: .warinning)
        case .write:
            self.imageViewResult.image = .image(dsimage: .write)
        }
        self.labelTitle.text = alert.title
        self.labelContent.text = alert.content
        self.cancleButton.isHidden = !alert.availableCancle

        self.cancleButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: false) {
                    alert.resultSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)

        self.okButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: false) {
                    alert.resultSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
    }

    private func initSetting() {
        layout()
    }

    open override func layout() {
        
        self.view.backgroundColor = .clear

        self.view.addSubview(buttonBackground)

        buttonBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.view.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(45)
            $0.trailing.equalToSuperview().inset(45)
            $0.center.equalToSuperview()
        }

        contentView.setRound(radius: 8)
        contentView.clipsToBounds = true
    }

    private func makeContentStackView() -> UIStackView {

        return UIStackView(arrangedSubviews: [
            imageViewResult,
            labelTitle,
            labelContent
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 20)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
            $0.spacing = 12
        }
    }

    private func markButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            cancleButton,
            okButton
        ]).then {
            $0.distribution = .fillEqually
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
