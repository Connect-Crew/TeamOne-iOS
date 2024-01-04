//
//  ManageProjecBottomShet.swift
//  TeamOne
//
//  Created by 강현준 on 1/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import Then
import DSKit
import Core
import Domain
import RxSwift
import RxCocoa

final class ManageProjecBottomSheet: View {
    
    let viewTopGrayIndicator = UIView().then {
        $0.setRound(radius: 5)
        $0.backgroundColor = .init(r: 234, g: 234, b: 234, a: 1)
    }
    
    let labelManageProject = UILabel().then {
        $0.setLabel(text: "프로젝트 관리", typo: .title1, color: .teamOne.grayscaleEight)
        $0.textAlignment = .center
    }

    let buttonClose = UIButton().then {
        $0.setButton(text: "닫기", typo: .body3, color: .teamOne.grayscaleSeven)
    }
    
    let buttonManageApplicants = UIButton().then {
        $0.setButton(text: "지원자 관리", typo: .button1, color: .white)
        $0.backgroundColor = .teamOne.mainColor
        $0.setRound(radius: 8)
        $0.setLayer(width: 1, color: .teamOne.mainColor)
    }
    
    let buttonModified = UIButton().then {
        $0.setButton(text: "수정하기", typo: .button1, color: .teamOne.mainColor)
        $0.backgroundColor = .teamOne.white
        $0.setRound(radius: 8)
        $0.setLayer(width: 1, color: .teamOne.mainColor)
    }
    
    let buttonDelete = UIButton().then {
        $0.setButton(text: "삭제하기", typo: .button1, color: .teamOne.mainColor)
        $0.backgroundColor = .teamOne.white
        $0.setRound(radius: 8)
        $0.setLayer(width: 1, color: .teamOne.mainColor)
    }
    
    let imageViewWarnning = UIImageView().then {
        $0.image = .image(dsimage: .warinning)
        $0.contentMode = .scaleAspectFit
    }
    
    let labelWarnning = UILabel().then {
        $0.setLabel(text: "팀원이 한 명 이상 생기면 프로젝트를 삭제할 수 없습니다.", typo: .caption2, color: .teamOne.point)
    }
    
    private let divider = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleTwo)
    }
    
    let buttonComplete = UIButton().then {
        $0.setButton(text: "프로젝트 완수", typo: .button1, color: .teamOne.point)
        $0.backgroundColor = .teamOne.white
        $0.setRound(radius: 8)
        $0.setLayer(width: 1, color: .teamOne.point)
    }
    
    private lazy var topIndicatorStackView = UIStackView(arrangedSubviews: [viewTopGrayIndicator]).then {
        $0.alignment = .center
        $0.axis = .vertical
    }
    
    private lazy var warnningStackView = UIStackView(arrangedSubviews: [
        imageViewWarnning,
        labelWarnning
    ]).then {
        $0.spacing = 3
    }
    
    private lazy var contentView = UIStackView(arrangedSubviews: [
        topIndicatorStackView,
        labelManageProject,
        buttonManageApplicants,
        buttonModified,
        buttonDelete,
        warnningStackView,
        divider,
        buttonComplete
    ]).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.layoutMargins = UIEdgeInsets(top: 8, left: 24, bottom: 24, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        
        $0.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        $0.backgroundColor = .white
        $0.setCustomSpacing(25, after: topIndicatorStackView)
        $0.setCustomSpacing(28, after: labelManageProject)
        $0.setCustomSpacing(15, after: divider)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    func layout() {
        layoutSize()
        layoutContentView()
        layoutCloseButton()
    }
    
    func layoutSize() {
        viewTopGrayIndicator.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(5)
        }
        
        [buttonManageApplicants, buttonModified, buttonDelete, buttonComplete]
            .forEach {
                $0.snp.makeConstraints{
                    $0.height.equalTo(52)
                }
            }
        
        imageViewWarnning.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
    
    func layoutContentView() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func layoutCloseButton() {
        addSubview(buttonClose)
        
        buttonClose.snp.makeConstraints {
            $0.centerY.equalTo(labelManageProject.snp.centerY)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Bind
    
    func bind(output: ManageProjectMainViewModel.Output) {
        
        // 팀원이 2명 이상이라 삭제가 불가능 한 경우 삭제버튼 비활성화 처리
        output.isDeletable
            .filter { $0 == false }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.buttonDelete.isEnabled = false
                self.buttonDelete.setLayer(width: 1, color: .teamOne.grayscaleFive)
                self.buttonDelete.setTitleColor(.teamOne.grayscaleFive, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
