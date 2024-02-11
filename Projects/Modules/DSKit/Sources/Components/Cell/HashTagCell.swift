//
//  HashTagCell.swift
//  DSKit
//
//  Created by Junyoung on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

import Core

import RxSwift
import RxCocoa

final class HashTagCell: UICollectionViewCell, CellIdentifiable {

    let disposeBag: DisposeBag = .init()

    let backgroundContainerView = UIView().then {
        $0.layer.cornerRadius = 10
    }

    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(text: "", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {

        contentView.addSubview(backgroundContainerView)

        backgroundContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        backgroundContainerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.left.right.equalToSuperview().inset(8)
        }

    }

    func initSetting(tag: HashTagDSModel) {
        self.titleLabel.text = tag.title

        switch tag.tagColor {
        case .gray:
            self.backgroundContainerView.backgroundColor = .teamOne.grayscaleTwo
            self.titleLabel.textColor = .teamOne.grayscaleSeven
        case .pink:
            self.backgroundContainerView.backgroundColor = .teamOne.pointTwo
            self.titleLabel.textColor = .teamOne.grayscaleSeven
        case .black:
            self.backgroundContainerView.backgroundColor = .teamOne.grayscaleSeven
            self.titleLabel.textColor = .teamOne.white
        }
    }

}
