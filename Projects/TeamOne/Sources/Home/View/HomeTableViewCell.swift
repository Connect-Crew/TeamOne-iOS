//
//  HomeTableViewCell.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core

final class HomeTableViewCell: UITableViewCell, CellIdentifiable {

    // MARK: - Properties

    let containerView = UIView().then {
        $0.backgroundColor = .clear
    }

    let mainImageView: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .red
    }

    let contentContainerView = UIView().then {
        $0.backgroundColor = .clear
    }

    let titleLabel = UILabel().then {
        $0.setLabel(text: "강아지 의료 플랫폼 기획", typo: .title1, color: .teamOne.grayscaleSeven)
    }

    // MARK: - Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func layout() {

        contentView.backgroundColor = .clear

        containerView.backgroundColor = .white

        self.backgroundColor = .clear

        contentView.addSubview(containerView)

        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(6)
        }

        containerView.addSubview(mainImageView)

        mainImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(mainImageView.snp.width)
        }

        containerView.addSubview(contentContainerView)

        contentContainerView.snp.makeConstraints {
            $0.leading.equalTo(mainImageView.snp.trailing).offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }

        contentContainerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }

    }
}
