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
    
    private let navBar = ProfileDetailNavBar()
    
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
        $0.setLabel(text: "안녕하세욧~!!!!!", typo: .caption1, color: .teamOne.grayscaleSeven)
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
    
    init() {
        super.init(frame: .zero)
        
        layout()
        scrollView.backgroundColor = .teamOne.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutNavBar()
        layoutScrollView()
        layoutProfileStackView()
        layoutParticipationStatusView()
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
            $0.bottom.equalToSuperview()
        }
    }
    

    private func makeNameHoneyStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [nameLabel, honeyImageView]).then {
            $0.spacing = 3
        }
    }
}
