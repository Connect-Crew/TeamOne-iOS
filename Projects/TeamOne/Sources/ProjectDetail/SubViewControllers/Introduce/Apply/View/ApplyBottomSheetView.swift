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
    
    enum ApplyState {
        case appliable
        case isQuotaFull
        case applied
        
        var bgColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainlightColor
            case .isQuotaFull:
                UIColor.teamOne.grayscaleTwo
            case .applied:
                UIColor.teamOne.white
            }
        }
        
        var layerColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainColor
            case .isQuotaFull:
                UIColor.clear
            case .applied:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var categoryTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainColor
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            case .applied:
                UIColor.teamOne.mainColor
            }
        }
        
        var partTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.grayscaleEight
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            case .applied:
                UIColor.teamOne.grayscaleEight
            }
        }
        
        var countTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.point
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            case .applied:
                UIColor.teamOne.point
            }
        }
        
        var introduceTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.grayscaleFive
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            case .applied:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var buttonBackgroundColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainColor
            case .isQuotaFull:
                UIColor.teamOne.grayscaleTwo
            case .applied:
                UIColor.teamOne.grayscaleTwo
            }
        }
        
        var buttonTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.white
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            case .applied:
                UIColor.teamOne.grayscaleFive
            }
        }
    }
    
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
        $0.setButton(text: "닫기", typo: .body3, color: .teamOne.grayscaleSeven)
    }
    
    let imageViewWarnning = UIImageView().then {
        $0.image = .image(dsimage: .warinning)
        
        $0.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
    
    let labelWarnning = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabel(text: "한 사람이 여러 직무를 맡을 수 있습니다. ex) A지원자가 기획, 디자인 중복 지원", typo: .caption2, color: .teamOne.point)
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
        scrollView
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        $0.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        $0.isLayoutMarginsRelativeArrangement = true
        
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
        $0.backgroundColor = .white
    }
    
    let scrollView = BaseScrollView().then {
        $0.backgroundColor = UIColor.teamOne.background
    }
    
    let selectedPartSubject = PublishSubject<RecruitStatus>()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    private func layout() {
        
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview()
        }
        
        addSubview(buttonClose)
        
        buttonClose.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(labelApply.snp.centerY)
        }
        
        scrollView.contentView.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(500)
        }
    }
    
    func setStatus(recruit: [RecruitStatus]) {
        
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        contentStackView.addArrangedSubview(makeWarnningStackView(subViews: [ imageViewWarnning, labelWarnning ]))
        
        guard !recruit.isEmpty else { return }
        
        recruit.forEach { data in
            
            var state = ApplyState.appliable
            
            if data.applied == true { state = .applied }
            if data.isQuotaFull == true { state = .isQuotaFull }
            
            let labelPart = UILabel().then {
                $0.setLabel(text: data.part, typo: .button2, color: state.partTextColor)
            }
            
            let labelCategory = UILabel().then {
                $0.setLabel(text: data.category, typo: .caption2, color: state.categoryTextColor)
            }
            
            let labelCount = UILabel().then {
                $0.setLabel(text: "\(data.current) / \(data.max)", typo: .caption2, color: state.countTextColor)
            }
            
            let labelIntroduce = UILabel().then {
                $0.setLabel(text: data.comment, typo: .caption1, color: state.introduceTextColor)
            }
            
            let applyButton = Button_IsEnabled(enabledString: "지원하기", disabledString: "지원마감").then {
                $0.titleLabel?.font = .setFont(font: .button2)
                $0.setRound(radius: 8)
                
                $0.snp.remakeConstraints{
                    $0.width.equalTo(76)
                    $0.height.equalTo(30)
                }
                
                if state == .applied {
                    $0.disabledString = "지원완료"
                }
                
                if state == .appliable {
                    $0.isEnabled = true
                } else {
                    $0.isEnabled = false
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
                $0.backgroundColor = state.bgColor
                $0.layer.borderColor = state.layerColor.cgColor
                $0.layer.borderWidth = 1
                $0.clipsToBounds = true
                $0.setRound(radius: 8)
            }
            
            contentStackView.addArrangedSubview(topStackView)
            
        }
    }
    
    func makeWarnningStackView(subViews: [UIView]) -> UIStackView {
        return UIStackView(arrangedSubviews: subViews).then {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .top
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

