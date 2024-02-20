//
//  FavoriteProjectCell.swift
//  DSKit
//
//  Created by 강현준 on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit

import Core

public class FavoriteProjectCell: UICollectionViewCell {
    
    private let thumbnailImageView = UIImageView().then {
        $0.image = .image(dsimage: .logo)
        $0.setRound(radius: 6)
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabel(text: "불편하면 자세를 고쳐앉아", typo: .body4, color: .teamOne.grayscaleEight)
    }
    
    private let likeButton = Button_IsLikedOnlyImage(isLiked: false)
    
    private let imageViewPerson = UIImageView(image: .image(dsimage: .count))
    
    private let labelCount = UILabel().then {
        $0.setLabel(text: "0/0", typo: .caption1, color: .teamOne.mainColor)
    }
    
    private let imageViewPlace = UIImageView().then {
        $0.image = .image(dsimage: .place)
    }
    
    private let labelIsOnline = UILabel().then {
        $0.setLabel(text: "알수없음", typo: .caption2, color: .teamOne.grayscaleSeven)
    }
    
    private let divider = UIView().then {
        $0.setDivider(height: 10, color: .teamOne.grayscaleSeven)
    }
    
    private let timeAgoLabel = UILabel().then {
        $0.setLabel(text: "XX전", typo: .caption2, color: .teamOne.grayscaleSeven)
    }
    
    private let mainStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let rightStackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 9.5, left: 8, bottom: 9.5, right: 7)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 4
        $0.axis = .vertical
    }
    
    private lazy var rightFirstStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        likeButton
    ]).then {
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private lazy var rightSecondStackView = UIStackView(arrangedSubviews: [
        imageViewPerson,
        labelCount,
        imageViewPlace,
        labelIsOnline,
        divider,
        timeAgoLabel,
        UIView()
    ]).then {
        $0.spacing = 5
        $0.alignment = .leading
        $0.setCustomSpacing(10, after: labelCount)
        $0.setCustomSpacing(0, after: imageViewPlace)
        $0.setCustomSpacing(4, after: labelIsOnline)
        $0.setCustomSpacing(4, after: divider)
        $0.setCustomSpacing(0, after: timeAgoLabel)
        $0.alignment = .center
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(71)
        }
        
        mainStackView.addArrangedSubview(rightStackView)
        
        rightStackView.addArrangedSubview(rightFirstStackView)
        
        likeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        rightStackView.addArrangedSubview(rightSecondStackView)
        
        imageViewPlace.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        imageViewPerson.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        contentView.setBaseShadow(radius: 8)
    }
}
