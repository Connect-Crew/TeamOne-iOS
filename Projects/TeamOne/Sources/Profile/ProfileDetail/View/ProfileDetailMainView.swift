//
//  ProfileDetailMainView.swift
//  TeamOne
//
//  Created by 강현준 on 2/13/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class ProfileDetailMainView: View {
    
    let navBar = ProfileDetailNavBar()
    
    private let scrollView = BaseScrollView()
    
    private let profileImageView = RoundableImageView().then {
        $0.image = .image(dsimage: .baseProfile)
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.setLabel(text: "잭재앙", typo: .body4, color: .teamOne.grayscaleEight)
    }
    
    private let honeyImageView = ImageView_Honey()
    
    private let careerLabel = UILabel().then {
        $0.setLabel(text: "", typo: .caption1, color: .teamOne.grayscaleFive)
        
        let firstPart = "탑"
        let firstCareer = "1년"
        let first = [firstPart, firstCareer].joined(separator: " ")
        
        let secondPart = "정글"
        let secondCareer = "2년"
        let second = [secondPart, secondCareer].joined(separator: " ")
        
        let attributedStr = NSMutableAttributedString(string: [first, second].joined(separator: ", "))
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.teamOne.point, range: (attributedStr.string as NSString).range(of: firstCareer))
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.teamOne.point, range: (attributedStr.string as NSString).range(of: secondCareer))
        
        $0.attributedText = attributedStr
        
    }
    
    private let introduceLabel = UILabel().then {
        $0.setLabel(text: "랄로와 기울어진 마라탕", typo: .caption1, color: .teamOne.grayscaleSeven)
        $0.textAlignment = .center
    }
    
    private let editButton = Button_Edit()
    
    private lazy var nameHoneyStackView = makeNameHoneyStackView()
    
    private lazy var profileStackView = UIStackView(
        arrangedSubviews: [
            profileImageView,
            nameHoneyStackView,
            careerLabel,
            introduceLabel,
            editButton
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 4
        $0.setCustomSpacing(8, after: profileImageView)
    }
    
    private let participationStatusView = ParticiPationStatusView()
    
    private let growthStatusView = GrowhStatusView()
    
    private let recentLoginDatelabel = UILabel().then {
        $0.setLabel(text: "최근 접속일 0000.00.00.", typo: .caption2, color: .grayscaleFive)
    }
    
    private let detailHoneyPolicyButton = UIButton().then {
        $0.setImage(.image(dsimage: .lv4), for: .normal)
        $0.setTitle("꿀단지 단위", for: .normal)
        $0.titleLabel?.font = .setFont(font: .caption1)
        $0.setTitleColor(.grayscaleSeven, for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .grayscaleTwo
    }
    
    private lazy var recentLoginStackView = UIStackView(arrangedSubviews: [
        recentLoginDatelabel,
        detailHoneyPolicyButton
    ]).then {
        $0.alignment = .bottom
    }
    
    private let viewProtfolioButton = Button_ViewPortfolio()
    
    private let representProjectTitleLabel = UILabel().then {
        $0.setLabel(text: "대표 프로젝트", typo: .body2, color: .grayscaleEight)
    }
    
    private let moreRepresentProjectButton = UIButton().then {
        $0.setImage(.image(dsimage: .rightsmall), for: .normal)
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.grayscaleFive, for: .normal)
        $0.setFont(typo: .caption2)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    private lazy var representProjectTitleStackView = UIStackView(arrangedSubviews: [
        representProjectTitleLabel,
        moreRepresentProjectButton
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let representDetailCollectionView = RepresentProjectCollectionView_Large()
    
    init() {
        super.init(frame: .zero)
        
        layout()
        scrollView.backgroundColor = .teamOne.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(output: ProfileDetailViewModel.Output) {
        
        bindRepresentProject(projects: output.representProject)
    }
    
    func lazyBind() {
        growthStatusView.setStatus(level: 3, exp: 30)
    }
    
    private func bindRepresentProject(projects: Observable<[Void]>) {
        projects
            .withUnretained(self)
            .bind(onNext: { this, projects in
                
                let numberOfItems = projects.count
                let numberOfRows = numberOfItems / 2
                
                let totalCellHeight = Double(numberOfRows) * RepresentProjectCollectionView_Large.cellheight
                let totalSpacing = Double(numberOfRows - 1) * RepresentProjectCollectionView_Large.lineSpacing
                
                this.representDetailCollectionView.snp.remakeConstraints {
                    $0.top.equalTo(this.representProjectTitleStackView.snp.bottom).offset(4)
                    $0.leading.equalToSuperview().offset(24)
                    $0.trailing.equalToSuperview().inset(24)
                    $0.height.equalTo(totalCellHeight + totalSpacing)
                    $0.bottom.equalToSuperview()
                }
                
                this.representDetailCollectionView.setProjects(projects: projects.map { DSRepresentProject_Detail(thumbnail: "", title: "", startDay: "", endDay: "")})
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    private func layout() {
        layoutNavBar()
        layoutScrollView()
        layoutProfileStackView()
        layoutParticipationStatusView()
        layoutGrowthStatusView()
        layoutRecentLogin()
        layoutPortfolio()
        layoutRepresentProject()
    }
    
    private func layoutNavBar() {
        self.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.contentView.backgroundColor = .teamOne.background
    }
    
    private func layoutProfileStackView() {
        
        scrollView.contentView.addSubview(profileStackView)
        
        profileStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
    }
    
    private func layoutParticipationStatusView() {
        scrollView.contentView.addSubview(participationStatusView)
        
        participationStatusView.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func layoutGrowthStatusView() {
        scrollView.contentView.addSubview(growthStatusView)
        
        growthStatusView.snp.makeConstraints {
            $0.top.equalTo(participationStatusView.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func layoutRecentLogin() {
        
        scrollView.contentView.addSubview(recentLoginStackView)
        
        recentLoginStackView.snp.makeConstraints {
            $0.top.equalTo(growthStatusView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        detailHoneyPolicyButton.snp.makeConstraints {
            $0.width.equalTo(94)
            $0.height.equalTo(28)
        }
    }
    
    private func layoutPortfolio() {
        scrollView.contentView.addSubview(viewProtfolioButton)
        viewProtfolioButton.snp.makeConstraints {
            $0.top.equalTo(recentLoginStackView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func layoutRepresentProject() {
        
        scrollView.contentView.addSubview(representProjectTitleStackView)
        
        representProjectTitleStackView.snp.makeConstraints {
            $0.top.equalTo(viewProtfolioButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        scrollView.contentView.addSubview(representDetailCollectionView)
        
    }
    
    private func makeNameHoneyStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [nameLabel, honeyImageView]).then {
            $0.spacing = 3
        }
    }
}
