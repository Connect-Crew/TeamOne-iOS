//
//  MyProfileCard.swift
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

final class MyProfileCard: UIView {
    
    let topView = UIView()
    let bottomView = UIView()
    
    let profileButton = UIButton()
    
    let topContainerView = UIView()
    
    let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
        $0.distribution = .fillEqually
    }
    
    let profileImage = UIImageView().then {
        $0.image = .image(dsimage: .baseProfile)
    }
    let nameView = UIView()
    let honeyPotImageView = ImageView_Honey(type: .small).then {
        $0.setHoney(temparature: 10)
    }
    
    let nameLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    let careerLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    let aboutMeLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    let rightButtonImageView = UIImageView().then {
        $0.image = .image(dsimage: .rightsmall)
    }
    
    let mainProjectLabel = UILabel().then {
        $0.setLabel(text: "대표 프로젝트", typo: .caption2, color: .teamOne.grayscaleSeven)
    }
    
    let emptyMainProject = View_EmptyRepresentProject()
    
    let mainProjectContainerView = UIView()
    
    let projectStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .leading
        $0.distribution = .fillEqually
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.layer.cornerRadius = 8
        
        self.setBaseShadow(radius: 8)
        
        addSubview(topView)
        addSubview(bottomView)
        
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(83)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(97)
        }
        
        topView.addSubview(topContainerView)
        topContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        topContainerView.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.top.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(3)
        }
        
        topContainerView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(12)
            make.top.bottom.equalToSuperview()
        }
        
        nameView.addSubview(nameLabel)
        nameView.addSubview(honeyPotImageView)
        nameView.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        honeyPotImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.left.equalTo(nameLabel.snp.right).offset(2)
            make.centerY.equalToSuperview()
            // TODO: 제약 깨짐
            make.right.lessThanOrEqualToSuperview().offset(0)
        }
        
        [nameView, careerLabel, aboutMeLabel]
            .forEach { labelStackView.addArrangedSubview($0) }
        
        topContainerView.addSubview(rightButtonImageView)
        rightButtonImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.left.equalTo(labelStackView.snp.right)
            make.top.right.equalToSuperview()
        }
        
        topView.addSubview(profileButton)
        profileButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomView.addSubview(mainProjectLabel)
        mainProjectLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        bottomView.addSubview(mainProjectContainerView)
        mainProjectContainerView.snp.makeConstraints { make in
            make.top.equalTo(mainProjectLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        mainProjectContainerView.addSubview(emptyMainProject)
        emptyMainProject.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainProjectContainerView.addSubview(projectStackView)
        projectStackView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
    }
}

extension MyProfileCard {
    func addMainProject(_ model: [RepresentProject]) {
        
        guard !model.isEmpty else {
            self.emptyMainProject.isHidden = false
            return
        }
        
        self.emptyMainProject.isHidden = true
        
        model.forEach { _ in
            let view = UIView().then {
                $0.backgroundColor = .black
                $0.layer.cornerRadius = 4
            }
            let imageView = UIImageView()
            let button = UIButton()
            
            view.snp.makeConstraints { make in
                make.height.equalTo(60)
                make.width.equalTo(92)
            }
            
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            projectStackView.addArrangedSubview(view)
        }
    }
}
