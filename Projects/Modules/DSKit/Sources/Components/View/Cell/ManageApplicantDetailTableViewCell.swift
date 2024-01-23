//
//  ManageApplicantDetailTableViewCell.swift
//  DSKit
//
//  Created by 강현준 on 1/23/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import SnapKit
import Then
import RxSwift
import RxCocoa

/// 지원자 관리 Detail TableViewCell
public final class ManageApplicantDetailTableViewCell: UITableViewCell, CellIdentifiable {

    public enum ApplicationStatus {
        /// 지원이 수락된 상태
        case approved
        /// 지원이 거절된 상태
        case rejected
        /// 지원이 아직 결정되지 않은 미 결재 상태
        case pending
        
        var cellBackgrouncColor: UIColor {
            switch self {
            case .approved: return .teamOne.white
            case .rejected: return .teamOne.white
            case .pending: return .teamOne.mainlightColor
            }
        }
        
        var reviewButtonisHidden: Bool {
            switch self {
            case .approved, .rejected: return true
            case .pending: return false
            }
        }
        
        var isReviewedDateLabelHidden: Bool {
            switch self {
            case .pending: return false
            case .approved, .rejected: return true
            }
        }
        
        var reviewdStateLabeTextColor: UIColor {
            switch self {
            case .approved: return .teamOne.mainColor
            case .rejected: return .teamOne.point
            default: return .clear
            }
        }
    }
    
    private let profileImageView: UIImageView = UIImageView().then {
        $0.image = .image(dsimage: .baseProfile)
    }
    
    private let labelName = UILabel().then {
        $0.setLabel(text: "김찬호", typo: .body4, color: .teamOne.grayscaleEight)
    }
    
    private let imageViewHodey = ImageView_Honey(type: .small)
    
    private let labelPart = UILabel().then {
        $0.setLabel(text: "잭스", typo: .caption2, color: .teamOne.grayscaleFive)
    }
    
    private let labelIntroduction = UILabel().then {
        $0.setLabel(text: "가세요라", typo: .caption1, color: .teamOne.grayscaleSeven)
    }
    
    private let copyButton = UIButton().then {
        $0.setButton(image: .copy)
    }
    
    private let labelContact = UILabel().then {
        $0.setLabel(text: "010-2400-2400", typo: .button2, color: .teamOne.mainColor)
    }
    
    private let textViewIntroduction = UITextView().then {
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.font = .setFont(font: .button2)
        $0.textColor = .teamOne.grayscaleSeven
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.setRound(radius: 8)
        $0.text = "마루쉐!!!!!!!!!!"
    }
    
    private let rejectButton = UIButton().then {
        $0.setButton(text: "거절", typo: .button1, color: .teamOne.grayscaleSeven)
        $0.setRound(radius: 8)
        $0.backgroundColor = .teamOne.grayscaleTwo
    }
    
    private let approveButton = UIButton().then {
        $0.setButton(text: "승인", typo: .button1, color: .teamOne.white)
        $0.setRound(radius: 8)
        $0.backgroundColor = .teamOne.mainColor
    }
    
    private let labelReviewdDate = UILabel().then {
        $0.setLabel(text: "2400.00.00", typo: .caption2, color: .teamOne.grayscaleFive)
        $0.textAlignment = .right
    }
    
    private let labelReviewdType = UILabel().then {
        $0.setLabel(text: "찬호", typo: .caption2, color: .teamOne.mainColor)
    }
    
    private lazy var profileStackView = UIStackView(arrangedSubviews: [
        profileImageView,
        makeProfileVerticalStackView()
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 12
        $0.setBaseShadow(radius: 8)
        $0.setRound(radius: 8)
    }
     
    private lazy var contactStackView = UIStackView(arrangedSubviews: [        makeContactInfoStackView()
    ]).then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        rejectButton,
        approveButton
    ]).then {
        $0.spacing = 20
        $0.distribution = .fillEqually
    }
    
    private lazy var reviewedStackView = UIStackView(arrangedSubviews: [
        labelReviewdDate,
        labelReviewdType
    ]).then {
        $0.spacing = 2
        $0.alignment = .trailing
    }
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [
        profileStackView,
        contactStackView,
        textViewIntroduction,
        buttonStackView,
        reviewedStackView
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let profileContainerButton = UIButton()
    
    public var disposeBag = DisposeBag()
    
    private lazy var applcationStatus: ApplicationStatus = .pending
    
    public let rejectTap = PublishRelay<Void>()
    public let approveTap = PublishRelay<Void>()
    public let profileTap = PublishRelay<Void>()
    public let copyButtonTap = PublishRelay<Void>()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    private func layout() {
        
        self.selectionStyle = .none
        
        // ImageView
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        // contentView
        contentView.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // copyButton
        copyButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        // button
        
        [approveButton, rejectButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(52)
            }
        }

        
        contentView.addSubview(profileContainerButton)
        
        profileContainerButton.snp.makeConstraints {
            $0.edges.equalTo(profileStackView)
        }
    }
    
    public func bind() {
        
        rejectButton.rx.tap
            .bind(to: rejectTap)
            .disposed(by: disposeBag)
        
        approveButton.rx.tap
            .bind(to: approveTap)
            .disposed(by: disposeBag)
        
        copyButton.rx.tap
            .bind(to: copyButtonTap)
            .disposed(by: disposeBag)
        
        profileContainerButton.rx.tap
            .bind(to: profileTap)
            .disposed(by: disposeBag)
        
        
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.setRoundCircle()
    }
    
    func makeProfileVerticalStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            makeProfileNameStackView(),
            labelPart,
            labelIntroduction
        ]).then {
            $0.axis = .vertical
            $0.spacing = 2
        }
        
        func makeProfileNameStackView() -> UIStackView {
            return UIStackView(arrangedSubviews: [
                labelName,
                imageViewHodey,
                UIView()
            ]).then {
                $0.spacing = 2
            }
        }
    }
    
    func makeContactInfoStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelContact,
                    copyButton
        ]).then {
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 10
            $0.setRound(radius: 8)
            $0.backgroundColor = .teamOne.mainlightColor
            $0.setLayer(width: 1, color: .teamOne.mainColor)
        }
    }
}
