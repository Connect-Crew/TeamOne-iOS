//
//  ApplicantManageCell.swift
//  DSKit
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import SnapKit
import Then
import RxSwift
import RxCocoa

public struct DSManageApplicantMainTableViewCellData {
    let part: String
    let partKey: String
    let category: String
    let comment: String
    let current: Int
    let max: Int
    let isQuotaFull: Bool
    
    public init(part: String, partKey: String, category: String, comment: String, current: Int, max: Int, isQuotaFull: Bool) {
        self.part = part
        self.partKey = partKey
        self.category = category
        self.comment = comment
        self.current = current
        self.max = max
        self.isQuotaFull = isQuotaFull
    }
}

/// 지원자관리 > TableViewCell
public final class ManageApplicantMainTableViewCell: UITableViewCell, CellIdentifiable {
    
    public enum ApplicantManageCellState {
        case appliable
        case isQuotaFull
        
        var bgColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainlightColor
            case .isQuotaFull:
                UIColor.teamOne.grayscaleTwo
            }
        }
        
        var layerColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainColor
            case .isQuotaFull:
                UIColor.clear
            }
        }
        
        var categoryTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.mainColor
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var partTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.grayscaleEight
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var countTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.point
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var introduceTextColor: UIColor {
            switch self {
            case .appliable:
                UIColor.teamOne.grayscaleFive
            case .isQuotaFull:
                UIColor.teamOne.grayscaleFive
            }
        }
        
        var buttonImage: UIImage? {
            switch self {
            case .appliable:
                return .image(dsimage: .arrowRightBlue)
            case .isQuotaFull:
                return .image(dsimage: .arrowRightGray)
            }
        }
    }
    
    private let labelPart = UILabel().then {
        $0.setLabel(text: "김찬호", typo: .button2, color: .black)
    }
    
    private let labelCategory = UILabel().then {
        $0.setLabel(text: "스트리머", typo: .caption2, color: .black)
    }
    
    private let labelCount = UILabel().then {
        $0.setLabel(text: "\(1600) / \(2400)", typo: .caption2, color: .black)
    }
    
    private let labelIntroduce = UILabel().then {
        $0.setLabel(text: "가세요라", typo: .caption1, color: .black)
    }
    
    private let manageButton = UIButton().then {
        $0.setButton(image: .arrowRightGray)
    }
    
    private lazy var horizontalPartStackView = UIStackView(arrangedSubviews: [
        labelPart,
        labelCategory,
        labelCount,
        UIView()
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private lazy var verticalStackView = UIStackView(arrangedSubviews: [
        horizontalPartStackView,
        labelIntroduce
    ]).then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [
        verticalStackView,
        manageButton
    ]).then {
        $0.axis = .horizontal
        $0.setRound(radius: 8)
        $0.layoutMargins = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let spacingView = UIView()
    
    private var state: ManageApplicantMainTableViewCell.ApplicantManageCellState = .appliable
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.contentView.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview()
        }
        
        self.contentView.addSubview(spacingView)
        
        spacingView.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.top.equalTo(contentStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        manageButton.snp.makeConstraints {
            $0.width.equalTo(25)
        }
    }
    
    public func initSetting(
        data: DSManageApplicantMainTableViewCellData
    ) {
        
        self.state = data.isQuotaFull == true ? .isQuotaFull : .appliable
        
        self.labelPart.text = data.part
        self.labelCategory.text = data.category
        self.labelCount.text =  "\(data.current) / \(data.max)"
        self.labelIntroduce.text = data.comment
        
        if data.comment.isEmpty {
            labelIntroduce.text = " "
        }
        
        self.labelPart.textColor = state.partTextColor
        self.labelCategory.textColor = state.categoryTextColor
        self.labelCount.textColor = state.countTextColor
        self.labelIntroduce.textColor = state.introduceTextColor
        self.contentStackView.setLayer(width: 1, color: state.layerColor)
        self.contentStackView.backgroundColor = state.bgColor
        self.manageButton.setImage(state.buttonImage, for: .normal)
        
    }
    
}
