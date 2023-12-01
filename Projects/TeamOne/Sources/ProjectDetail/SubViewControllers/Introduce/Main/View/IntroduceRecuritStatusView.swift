//
//  IntroduceRecuritStatusView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/28.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import SnapKit
import Then
import Domain
import RxSwift
import RxCocoa

final class IntroduceRecuritStatusView: UIView {

    let imageViewPerson = UIImageView(image: .image(dsimage: .count))

    let labelStatus = UILabel().then {
        $0.setLabel(text: "모집현황", typo: .body4, color: .teamOne.mainColor)
    }

    let labelCount = UILabel().then {
        $0.setLabel(text: "0/0", typo: .body4, color: .teamOne.mainColor)
    }

    let countNow: Int = 0
    let countTarget: Int = 0

    lazy var contentView = UIStackView(arrangedSubviews: [
        createFirstStackView()
    ]).then {
        $0.axis = .vertical
    }

    init() {
        super.init(frame: .zero)
        initSetting()
    }

    func createFirstStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            imageViewPerson,
            labelStatus,
            labelCount,
            UIView()
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.backgroundColor = .teamOne.mainlightColor

            $0.layoutMargins = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSetting() {
        self.setRound(radius: 8)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.teamOne.mainColor.cgColor

        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setStatus(status: [RecruitStatus]) {

        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        status.forEach { data in

            let isEnable = data.max > data.current

            let categoryTextColor = isEnable ? UIColor.teamOne.mainColor : UIColor.teamOne.grayscaleFive

            let partTextColor = isEnable ? UIColor.teamOne.grayscaleSeven : UIColor.teamOne.grayscaleFive

            let countTextColor = isEnable ? UIColor.teamOne.point : UIColor.teamOne.grayscaleFive

            let bgColor = isEnable ? UIColor.teamOne.mainlightColor : UIColor.teamOne.white

            let labelCategory = UILabel().then {
                $0.setLabel(text: data.category, typo: .caption2, color: categoryTextColor)
                $0.textAlignment = .center
                $0.snp.makeConstraints {
                    $0.width.equalTo(70)
                }
            }

            let labelPart = UILabel().then {
                $0.setLabel(text: data.part, typo: .button2, color: partTextColor)
            }

            let labelCount = UILabel().then {
                $0.setLabel(text: "\(data.current) / \(data.max)", typo: .button2, color: countTextColor)
                $0.textAlignment = .right
            }

            let stackView = UIStackView(arrangedSubviews: [
                labelCategory,
                labelPart,
                UIView(),
                labelCount
            ]).then {
                $0.axis = .horizontal
                $0.alignment = .center
                $0.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 24)
                $0.isLayoutMarginsRelativeArrangement = true
                $0.backgroundColor = bgColor
            }

            contentView.addArrangedSubview(stackView)
        }
    }
}

extension Reactive where Base: IntroduceRecuritStatusView {
    var status: Binder<[RecruitStatus]> {
        return Binder(self.base) { view, status in
            view.setStatus(status: status)
        }
    }
}
