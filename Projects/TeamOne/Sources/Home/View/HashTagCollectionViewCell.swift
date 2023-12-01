//
//  HashTagCollectionViewCell.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

import Core
import Domain

import RxSwift
import RxCocoa

final class HashTagCollectionViewCell: UICollectionViewCell, CellIdentifiable {

    let disposeBag: DisposeBag = .init()

    let backgroundImageView = UIImageView()

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

        contentView.addSubview(backgroundImageView)

        backgroundImageView.snp.contentHuggingVerticalPriority = 749

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(backgroundImageView)
        }

    }

    func initSetting(tag: HashTag) {
        self.titleLabel.text = tag.title

        switch tag.titleColor {
        case .gray:
            self.titleLabel.textColor = .teamOne.grayscaleSeven
        }

        switch tag.background {
        case .gray:
            self.backgroundImageView.image = .image(dsimage: .tagGray)
        case .pink:
            self.backgroundImageView.image = .image(dsimage: .tagRed)
        }
    }

}
