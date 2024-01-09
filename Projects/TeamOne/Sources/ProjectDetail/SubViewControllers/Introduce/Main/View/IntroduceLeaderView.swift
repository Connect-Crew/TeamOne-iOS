//
//  IntroduceLeaderView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/28.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import SnapKit
import Then
import Domain
import RxSwift
import RxCocoa

final class IntroduceLeaderView: UIView {

    var baseLeaderImage: UIImage? = .image(dsimage: .baseProfile)
    var baseResponseRateImage: UIImage? = .image(dsimage: .leaderResponseRate)

    var leader: Leader? = nil

    var imageViewLeader = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    var labelName = UILabel().then {
        $0.setLabel(text: "홍길동", typo: .body4, color: .teamOne.grayscaleSeven)
    }
    var labelLeader = UILabel().then {
        $0.setLabel(text: "리더", typo: .caption1, color: .teamOne.point)
    }

    var labelPart = UILabel().then {
        $0.setLabel(text: "도둑", typo: .caption1, color: .teamOne.grayscaleSeven)
    }

    var imageViewResponseRate = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    var labelResponseRate = UILabel().then {
        $0.setLabel(text: "리더 응답률 00%", typo: .caption2, color: .teamOne.mainColor)
    }

    init() {
        super.init(frame: .zero)

        initSetting()
    }

    lazy var contentView = UIStackView(arrangedSubviews: [
        imageViewLeader,
        createMiddleStackView(),
        UIView(),
        createResponseRateStackView()
    ]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }

    func initSetting() {

        self.backgroundColor = .white
        self.setRound(radius: 8)
        self.setBaseShadow(radius: 8)
        self.addSubview(contentView)

        self.imageViewLeader.image = baseLeaderImage
        self.imageViewResponseRate.image = baseResponseRateImage

        contentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(9.5)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(9.5)
        }
    }

    func createMiddleStackView() -> UIStackView {

        let nameStackView = UIStackView(arrangedSubviews: [labelName, labelLeader, UIView()]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fill
        }

        return UIStackView(arrangedSubviews: [nameStackView, labelPart, UIView()]).then {
            $0.axis = .vertical
            $0.spacing = 2
            $0.distribution = .fill
        }
    }
    
    // MARK: - 리더응답률
    func createResponseRateStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [imageViewResponseRate, labelResponseRate]).then {
            $0.axis = .vertical
            $0.spacing = 2
            $0.isHidden = true
        }
    }

    func setData(leader: Leader) {
        self.leader = leader

        labelName.text = leader.nickname
        labelPart.text = leader.parts.joined(separator: " ")
        labelResponseRate.text = "리더 응답률 \(leader.responseRate)%"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension Reactive where Base: IntroduceLeaderView {
    var leader: Binder<Leader> {
        return Binder(self.base) { view, leader in
            view.setData(leader: leader)
        }
    }
}
