//
//  ApplyBottomSheetView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import Then
import DSKit
import Core
import Domain
import RxSwift
import RxCocoa

extension Reactive where Base: ApplyBottomSheetView {
    var status: Binder<[RecruitStatus]> {
        return Binder(self.base) { view, status in
            view.setStatus(recruit: status)
        }
    }
}


final class ApplyBottomSheetView: UIView {

    let viewGray = UIView().then {
        $0.setRound(radius: 5)
        $0.backgroundColor = .init(r: 234, g: 234, b: 234, a: 1)

        $0.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(5)
        }

    }

    let viewApply = UIView().then {
        $0.backgroundColor = .white
    }

    let labelApply = UILabel().then {
        $0.setLabel(text: "지원하기", typo: .title1, color: .teamOne.grayscaleEight)
        $0.textAlignment = .center
    }

    let buttonClose = UIButton().then {
        $0.isUserInteractionEnabled = true
        $0.isEnabled = true
        $0.setButton(text: "닫기", typo: .body3, color: .teamOne.grayscaleSeven)
    }

    let contentStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 12
        $0.backgroundColor = UIColor.teamOne.background
    }

    lazy var grayStackView = UIStackView(arrangedSubviews: [viewGray]).then {
        $0.alignment = .center
        $0.axis = .vertical
    }

    lazy var contentView = UIStackView(arrangedSubviews: [
        grayStackView,
        labelApply,
        contentStackView
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        $0.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        $0.isLayoutMarginsRelativeArrangement = true

        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
        $0.backgroundColor = .white
    }

    let selectedPartSubject = PublishSubject<RecruitStatus>()
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    private func layout() {

        addSubview(contentView)

        addSubview(buttonClose)

        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview()
        }

        buttonClose.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(labelApply.snp.centerY)
        }
    }

    func setStatus(recruit: [RecruitStatus]) {

        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !recruit.isEmpty else { return }

        recruit.forEach { data in
            let isEnable = data.isAppliable

            let bgColor = isEnable ? UIColor.teamOne.mainlightColor : UIColor.teamOne.white

            let layerColor = isEnable ? UIColor.teamOne.mainColor : UIColor.teamOne.grayscaleFive

            let categoryTextColor = isEnable ? UIColor.teamOne.mainColor : UIColor.teamOne.grayscaleFive

            let partTextColor = isEnable ? UIColor.teamOne.grayscaleEight : UIColor.teamOne.grayscaleFive

            let countTextColor = isEnable ? UIColor.teamOne.point : UIColor.teamOne.grayscaleFive

            let introduceTextColor = UIColor.teamOne.grayscaleFive

            let buttonBackgroundColor = isEnable ? UIColor.teamOne.grayscaleTwo : UIColor.teamOne.mainColor

            let buttonTextColor = isEnable ? UIColor.teamOne.white : UIColor.teamOne.grayscaleFive

            let labelPart = UILabel().then {
                $0.setLabel(text: data.part, typo: .button2, color: partTextColor)
            }

            let labelCategory = UILabel().then {
                $0.setLabel(text: data.category, typo: .caption2, color: categoryTextColor)
            }

            let labelCount = UILabel().then {
                $0.setLabel(text: "\(data.current) / \(data.max)", typo: .caption2, color: countTextColor)
            }

            let labelIntroduce = UILabel().then {
                $0.setLabel(text: data.comment, typo: .caption1, color: introduceTextColor)
            }

            let applyButton = Button_IsEnabled(enabledString: "지원하기", disabledString: "지원마감").then {
                $0.isEnabled = isEnable
                $0.titleLabel?.font = .setFont(font: .button2)
                $0.setRound(radius: 8)

                $0.snp.makeConstraints {
                    $0.width.equalTo(76)
                    $0.height.equalTo(30)
                }
            }

            applyButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.selectedPartSubject.onNext(data)
                })
                .disposed(by: disposeBag)

            let horizontalCategoryStackView = UIStackView(arrangedSubviews: [
                labelPart,
                labelCategory,
                labelCount,
                UIView()
            ]).then {
                $0.axis = .horizontal
                $0.spacing = 4
            }

            let verticalStackView = UIStackView(arrangedSubviews: [
                horizontalCategoryStackView,
                labelIntroduce
            ]).then {
                $0.axis = .vertical
                $0.spacing = 2
            }

            let topStackView = UIStackView(arrangedSubviews: [
                verticalStackView,
                applyButton
            ]).then {

                $0.axis = .horizontal

                $0.layoutMargins = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
                $0.isLayoutMarginsRelativeArrangement = true
                $0.backgroundColor = bgColor
                $0.layer.borderColor = layerColor.cgColor
                $0.layer.borderWidth = 1
                $0.clipsToBounds = true
                $0.setRound(radius: 8)
            }

            contentStackView.addArrangedSubview(topStackView)

        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.bringSubviewToFront(buttonClose)
    }

}

