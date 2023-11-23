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

//    func configure(hashTag: ?) {
//        guard let hashTag = hashTag else { return }
//
//        titleLabel.text = hashTag.title
//
//        if hashTag.backgroundColor == "gray" {
//            backgroundImageView.image = .image(dsimage: .tagGray)
//        } else if hashTag.backgroundColor == "pink" {
//            backgroundImageView.image = .image(dsimage: .tagRed)
//        }
//    }

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

}
