//
//  MyProfileView.swift
//  TeamOne
//
//  Created by Junyoung on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit
import Domain

final class MyProfileView: UIView {
    
    private let headerView = UIView()
    private let headerTitle = UILabel().then {
        $0.setLabel(text: "나의 프로필", typo: .body4, color: .teamOne.grayscaleEight)
    }
    
    private let profileCardView = MyProfileCard()
    
    private let dividerView = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleTwo)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(38)
        }
        
        headerView.addSubview(headerTitle)
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
        }
        
        addSubview(profileCardView)
        profileCardView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview().inset(24)
        }
        bind()
        
        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(profileCardView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension MyProfileView {
    func bind() {
        profileCardView.nameLabel.setLabel(text: "김찬호", typo: .body4, color: .teamOne.grayscaleEight)
        profileCardView.careerLabel.setLabel(text: "ios 2년amsefiasefoi", typo: .caption2, color: .teamOne.grayscaleFive)
        profileCardView.aboutMeLabel.setLabel(text: "240024002400", typo: .caption1, color: .teamOne.grayscaleSeven)
        
        // 대표 프로젝트 여부
        profileCardView.addMainProject([RepresentProject(id: 0, thumbnail: "aoiefioasejf"),
                                        RepresentProject(id: 0, thumbnail: "aoiefioasejf"),
                                        RepresentProject(id: 0, thumbnail: "aoiefioasejf")])
        
    }
}
