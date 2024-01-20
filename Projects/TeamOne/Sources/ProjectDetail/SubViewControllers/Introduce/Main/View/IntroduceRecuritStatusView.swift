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
import Core

final class IntroduceRecuritStatusView: View {
    
    enum IntroduceRecruitStatus {
        case appliable
        case isQuotafull
        case allPartQuotafull
        
        var categoryTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainColor
            case .isQuotafull:
                UIColor.teamOne.grayscaleFive
            case .allPartQuotafull:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var partTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.grayscaleSeven
            case .isQuotafull:
                UIColor.teamOne.grayscaleFive
            case .allPartQuotafull:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var countTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.point
            case .isQuotafull:
                UIColor.teamOne.grayscaleFive
            case .allPartQuotafull:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var bgColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainlightColor
            case .isQuotafull:
                UIColor.teamOne.white
            case .allPartQuotafull:
                UIColor.teamOne.white
            }
        }
    }

    let imageViewPerson = UIImageView(image: .image(dsimage: .count))

    let labelStatus = UILabel().then {
        $0.setLabel(text: "모집현황", typo: .body4, color: .teamOne.mainColor)
    }

    let labelCount = UILabel().then {
        $0.setLabel(text: "0/0", typo: .body4, color: .teamOne.mainColor)
    }

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
    
    func bind(output: ProjectDetailMainViewModel.Output) {
        let project = output
            .project
            .compactMap { $0 }
        
        project
            .drive(onNext: { [weak self] project in
                self?.setStatus(
                    status: project.recruitStatus,
                    isAppliableProject: project.isAppliable
                )
            })
            .disposed(by: disposeBag)
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

    func setStatus(status: [RecruitStatus], isAppliableProject: Bool) {

        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        status.forEach { data in

            var state = IntroduceRecruitStatus.appliable
            
            if data.max > data.current { state = .appliable }
            
            if isAppliableProject == false { state = .allPartQuotafull }

            let labelCategory = UILabel().then {
                $0.setLabel(text: data.category, typo: .caption2, color: state.categoryTextColor)
                $0.textAlignment = .center
                $0.snp.makeConstraints {
                    $0.width.equalTo(70)
                }
            }

            let labelPart = UILabel().then {
                $0.setLabel(text: data.part, typo: .button2, color: state.partTextColor)
            }

            let labelCount = UILabel().then {
                $0.setLabel(text: "\(data.current) / \(data.max)", typo: .button2, color: state.countTextColor)
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
                $0.backgroundColor = state.bgColor
            }

            contentView.addArrangedSubview(stackView)
        }
        
        layoutContentView(isAppliableProject: isAppliableProject)
    }
    
    func layoutContentView(isAppliableProject: Bool) {
        imageViewPerson.tintColor = .teamOne.grayscaleFive
        labelCount.textColor = .teamOne.grayscaleFive
        labelStatus.textColor = .teamOne.grayscaleFive
    }
}
