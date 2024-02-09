//
//  MemberListCell.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit
import Domain

final class MemberListCell: UICollectionViewCell, CellIdentifiable {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    enum MemberListCellType {
        case member
        case leader
    }
    
    private let imageViewProfile = UIImageView().then {
        $0.image = .image(dsimage: .baseProfile)
    }
    
    private let labelName = UILabel().then {
        $0.setLabel(text: "김찬호", typo: .body4, color: .teamOne.grayscaleEight)
    }
    
    private let imageViewHoney = ImageView_Honey()
    
    private let labelIsLeader = UILabel().then {
        $0.setLabel(text: "리더", typo: .caption1, color: .teamOne.point)
    }
    
    private let buttonGoProfile = UIButton().then {
        $0.setButton(image: .rightsmall)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        $0.contentVerticalAlignment = .top
        $0.isEnabled = false
    }
    
    private let labelPartString = UILabel().then {
        $0.setLabel(text: "역할", typo: .caption2, color: .teamOne.mainColor)
    }
    
    private let labelPart = UILabel().then {
        $0.setLabel(text: "트린다미어", typo: .caption2, color: .teamOne.grayscaleFive)
    }
    
    private let labelIntroduce = UILabel().then {
        $0.setLabel(text: "2400!2400!2400!", typo: .caption1, color: .teamOne.grayscaleSeven)
    }
    
    private let labelRepresentProject = UILabel().then {
        $0.setLabel(text: "대표 프로젝트", typo: .caption2, color: .teamOne.grayscaleFive)
    }
    
    private lazy var collectionViewRepresentProject = RepresentProjectCollectionView()
    
    private let emtpyView = View_EmptyRepresentProject()
    
    private let divider = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleTwo)
    }
    
    private let expelMemberButton = UIButton().then {
        $0.setButton(text: "내보내기", typo: .caption1, color: .teamOne.grayscaleFive)
        $0.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private lazy var profileCenterStackView = UIStackView(arrangedSubviews: [
        makeHorizontalStackView(
            subviews: [labelName, imageViewHoney, labelIsLeader, UIView()],
            spacing: 5),
        makeHorizontalStackViewLeading(subviews: [labelPartString, labelPart, UIView()],
                                spacing: 3),
        labelIntroduce,
        UIView()
    ]).then {
        $0.spacing = 2
        $0.axis = .vertical
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        buttonGoProfile,
        UIView()
    ]).then {
        $0.axis = .vertical
        $0.alignment = .top
    }
    
    private lazy var profileStackView = UIStackView(arrangedSubviews: [
        imageViewProfile,
        profileCenterStackView,
        UIView(),
        buttonStackView
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.setCustomSpacing(0, after: profileCenterStackView)
    }
    
    private lazy var representStackView = UIStackView(arrangedSubviews: [
        labelRepresentProject,
        collectionViewRepresentProject
    ]).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    
    private lazy var expelMemberStackView = UIStackView(arrangedSubviews: [
        divider,
        expelMemberButton
    ]).then {
        $0.axis = .vertical
    }
    
    private lazy var containerStackView = UIStackView(arrangedSubviews: [
        profileStackView,
        representStackView,
        expelMemberStackView
    ]).then {
        $0.axis = .vertical
    }
    
    private var type: MemberListCellType?
    private var member: ProjectMember?
    
    var representProjectTap: Observable<RepresentProject> {
        return collectionViewRepresentProject.didSelectCell
            .map { RepresentProject(id: $0.id, thumbnail: $0.thumbnail) }
    }
    var expelMemberSelected = PublishRelay<ProjectMember>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    public func initSetting(
        type: MemberListCellType?,
        member: ProjectMember
    ) {
        self.type = type
        self.member = member
        
        initSettingLayout()
        bind()
        let representProjects = member.profile.representProjects.map { DSRepresentProject(id: $0.id, thumbnail: $0.thumbnail) }
        collectionViewRepresentProject.setProjects(projects: representProjects)
        
    }
    
    private func initSettingLayout() {
        
        guard let type = self.type,
        let member = member else { return }
        
        self.imageViewProfile.setTeamOneImage(path: member.profile.profile)
        self.imageViewHoney.setHoney(temparature: member.profile.temperature)
        self.labelName.text = member.profile.nickname
        self.labelIsLeader.isHidden = !member.isLeader
        self.labelPart.text = member.parts.joined(separator: ",")
        self.labelIntroduce.text = member.profile.introduction
        
        switch type {
        case .member:
            setMember()
        case .leader:
            setLeader()
        }
    }
  
    private func setMember() {
        self.expelMemberStackView.isHidden = true
    }
    
    private func setLeader() {
        self.expelMemberStackView.isHidden = false
        
        if member?.isLeader == true {
            self.expelMemberStackView.isHidden = true
        }
    }
    
    private func layout() {
        layoutProfile()
        layoutContentView()
        layoutStackView()
        layoutRepresentProject()
    }
    
    private func layoutProfile() {
        imageViewProfile.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
    }
    
    private func layoutContentView() {
        self.contentView.backgroundColor = .white
        self.contentView.setBaseShadow(radius: 8)
        self.contentView.setRound(radius: 8)
    }
    
    private func layoutStackView() {
        
        self.contentView.addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutRepresentProject() {
        collectionViewRepresentProject.snp.makeConstraints {
            $0.height.equalTo(60)
        }
    }
    
    private func bind() {
        bindExpelButton()
    }
    
    private func bindExpelButton() {
        expelMemberButton.rx.tap
            .withUnretained(self)
            .map { this, _ in
                return this.member
            }
            .compactMap { $0 }
            .bind(to: expelMemberSelected)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeHorizontalStackView(subviews: [UIView], spacing: CGFloat) -> UIStackView {
        return UIStackView(arrangedSubviews: subviews)
            .then {
                $0.spacing = spacing
            }
    }
    
    private func makeHorizontalStackViewLeading(subviews: [UIView], spacing: CGFloat) -> UIStackView {
        return UIStackView(arrangedSubviews: subviews)
            .then {
                $0.spacing = spacing
                $0.alignment = .leading
            }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
        self.imageViewProfile.image = .image(dsimage: .baseProfile)
    }
}
