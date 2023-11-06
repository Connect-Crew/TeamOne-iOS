//
//  HomeDropDownTableViewCell.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/30.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import RxSwift

final class HomeDropDownTableViewCell: UITableViewCell, CellIdentifiable {

    var disposeBag: RxSwift.DisposeBag = .init()

    private let titleLabel = UILabel().then {
        $0.setLabel(text: "00", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    private let countLabel = UILabel().then {
        $0.setLabel(text: "0명", typo: .caption2, color: .teamOne.point)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {

        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(6)
        }

        titleLabel.snp.contentCompressionResistanceHorizontalPriority = 749
        titleLabel.snp.contentHuggingHorizontalPriority = 749

        addSubview(countLabel)

        countLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(8)
        }

        titleLabel.snp.contentCompressionResistanceHorizontalPriority = 750
        titleLabel.snp.contentHuggingHorizontalPriority = 750

    }
}
