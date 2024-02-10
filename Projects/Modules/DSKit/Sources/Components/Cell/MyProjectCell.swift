//
//  MyProjectCell.swift
//  DSKit
//
//  Created by Junyoung on 2/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit

import Core

public class MyProjectCell: UICollectionViewCell {
    
    private let thumnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.image = .image(dsimage: .logo)
    }
    
    private let projectTitleLabel = UILabel()
    
    private let locationPerioadContainerView = UIView()
    private let locationImageView = UIImageView().then {
        $0.image = .image(dsimage: .place)
    }
    private let locationPeriodLabel = UILabel()
    
    private let rightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
//    private let collectionView = UICollectionView()
    
    private var tagData = [String]()
    
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
        
        addSubview(thumnailImageView)
        
        thumnailImageView.snp.makeConstraints { make in
            make.width.height.equalTo(71)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
        }
        
        addSubview(projectTitleLabel)
        projectTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(thumnailImageView.snp.right).offset(8)
            make.top.right.equalToSuperview().inset(12)
        }
        
        addSubview(locationPerioadContainerView)
        locationPerioadContainerView.addSubview(locationImageView)
        locationPerioadContainerView.addSubview(locationPeriodLabel)
        
        locationImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.bottom.equalToSuperview().inset(4)
            make.left.equalToSuperview()
        }
        
        locationPeriodLabel.snp.makeConstraints { make in
            make.left.equalTo(locationImageView.snp.right)
            make.top.bottom.equalToSuperview().inset(4)
            make.right.equalToSuperview()
        }
        
        locationPerioadContainerView.snp.makeConstraints { make in
            make.left.equalTo(thumnailImageView.snp.right).offset(8)
            make.top.equalTo(projectTitleLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(12)
        }
        
//        contentView.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.left.equalTo(thumnailImageView.snp.right).offset(8)
//            make.top.equalTo(locationPerioadContainerView.snp.bottom).offset(4)
//            make.right.equalToSuperview().inset(12)
//            make.bottom.equalToSuperview().inset(12)
//        }
    }
    
    public func bind(_ model: MyProjectsDSModel) {
        
//        collectionView.delegate = self
        
        thumnailImageView.setTeamOneImage(path: model.thumbnail)
        
        projectTitleLabel.setLabel(text: model.title, typo: .body4, color: .teamOne.grayscaleEight)
        locationPeriodLabel.setLabel(
            text: "\(model.online ? "온라인" : model.region) | \(model.createdAt.toRelativeDateString())",
            typo: .caption2,
            color: .teamOne.grayscaleSeven)
        
        tagData = model.category
//        self.collectionView.reloadData()
    }
    
}

extension MyProjectCell: UICollectionViewDelegateFlowLayout {
    
}
