//
//  RecruitmentStatusDetailViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/21.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import SnapKit
import Domain
import Then
import DSKit
import RxSwift

enum RecuritmentStatusDetailResult {
    case detail(element: SideProjectListElement?)
}

final class RecruitmentStatusDetailViewController: ViewController {

    let buttonBackground = UIButton().then {
        $0.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.7)
    }

    let contentView = UIView().then {
        $0.backgroundColor = .white
    }

    lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }

    let element: SideProjectListElement?

    let navigation = PublishSubject<RecuritmentStatusDetailResult>()

    init(element: SideProjectListElement?) {
        self.element = element
        super.init(nibName: nil, bundle: nil)

        layout(element)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout(_ element: SideProjectListElement?) {
        self.view.backgroundColor = .clear
        layoutBackgroundButton()
        layoutContentView()
        layoutTitle(item: element)
        layoutStatusDetail(item: element)
        layoutBottomButton()
    }

    func layoutBackgroundButton() {
        view.addSubview(buttonBackground)

        buttonBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        buttonBackground.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    func layoutContentView() {
        
        view.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }

        contentView.setRound(radius: 8)

        contentView.clipsToBounds = true

        contentView.addSubview(mainStackView)

        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func layoutTitle(item: SideProjectListElement?) {

        var current = 0
        var max = 0

        if let item = item {
            item.recruitStatus.forEach {
                current += $0.current
                max += $0.max
            }
        }

        let button = Button_IsEnabledImage(
            text: "모집현황 \(current)/\(max)", typo: .body2,
            enabledImage: .count, disabledImage: .countDisable,
            enabledTextColor: .teamOne.mainColor, disabledTextColor: .teamOne.grayscaleFive)

        button.isEnabled = true
        button.adjustsImageWhenHighlighted = false

        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        mainStackView.addArrangedSubview(button)
    }

    func layoutStatusDetail(item: SideProjectListElement?) {
        guard let item = item else { return }

        item.recruitStatus.forEach { status in

            let positionLabel = UILabel().then {
                $0.setLabel(text: status.category, typo: .button2, color: .teamOne.grayscaleSeven)
                $0.textAlignment = .left
            }

            let countingLabel = UILabel().then {
                $0.setLabel(text: "\(status.current)/\(status.max)", typo: .button2, color: .teamOne.point)
                $0.textAlignment = .right
            }

            if status.max <= status.current {
                [positionLabel, countingLabel].forEach { $0.textColor = UIColor.teamOne.grayscaleFive }
            }

            let stackView = UIStackView(arrangedSubviews: [positionLabel, countingLabel])

            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 0

            stackView.layoutMargins = UIEdgeInsets(top: 13, left: 28, bottom: 13, right: 28)
            stackView.isLayoutMarginsRelativeArrangement = true

            mainStackView.addArrangedSubview(stackView)
        }
    }

    func layoutBottomButton() {
        let cancleButton = UIButton().then {
            $0.setButton(text: "취소", typo: .button2, color: .teamOne.grayscaleSeven)
            $0.backgroundColor = UIColor.teamOne.grayscaleTwo
        }

        let detailButton = UIButton().then {
            $0.setButton(text: "상세보기", typo: .button2, color: .white)
            $0.backgroundColor = UIColor.teamOne.mainColor
        }

        [cancleButton, detailButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(48)
            }
        }

        let stackView = UIStackView(arrangedSubviews: [cancleButton, detailButton])

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0

        mainStackView.addArrangedSubview(stackView)

        cancleButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        detailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
    }

    @objc func dismissViewController() {
        self.dismiss(animated: false, completion: {

        })
    }

    @objc func showDetail() {
        self.dismiss(animated: false, completion: {
            self.navigation.onNext(.detail(element: self.element))
        })
    }
}
