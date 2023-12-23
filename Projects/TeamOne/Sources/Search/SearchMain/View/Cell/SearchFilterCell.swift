//
//  SearchFilterCell.swift
//  TeamOne
//
//  Created by Junyoung on 12/13/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core

public enum FilterCellState {
    case normal
    case used
}

class SearchFilterCell: UICollectionViewCell {
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.teamOne.grayscaleOne.cgColor
    }
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView().then {
        $0.image = .image(dsimage: .downTow)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func layout() {
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.left.equalTo(titleLabel.snp.right).offset(2)
            make.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func bind(to type: ProjectFilterType) {
        titleLabel.setLabel(text: type.toString, typo: .caption1, color: .teamOne.grayscaleSeven)
        
        if type == .reset {
            imageView.image = .image(dsimage: .reset)
            containerView.layer.borderColor = UIColor.teamOne.grayscaleFive.cgColor
            containerView.backgroundColor = .teamOne.grayscaleTwo
        } else {
            imageView.image = .image(dsimage: .downTow)
            containerView.layer.borderColor = UIColor.teamOne.grayscaleOne.cgColor
            containerView.backgroundColor = .white
        }
    }
    
    public func cellState(_ type: FilterCellState) {
        switch type {
        case .normal:
            imageView.image = .image(dsimage: .downTow)
            titleLabel.textColor = .teamOne.grayscaleSeven
            containerView.layer.borderColor = UIColor.teamOne.grayscaleOne.cgColor
            containerView.backgroundColor = .white
        case .used:
            imageView.image = .image(dsimage: .downTow)
            titleLabel.textColor = .teamOne.mainColor
            containerView.layer.borderColor = UIColor.teamOne.mainColor.cgColor
            containerView.backgroundColor = .white
        }
    }
}
