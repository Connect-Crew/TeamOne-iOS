//
//  BaseSelectButtonCell.swift
//  DSKit
//
//  Created by 강현준 on 12/12/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import SnapKit

public final class BaseSelectButtonCell: UICollectionViewCell, CellIdentifiable {

    public var disposeBag: RxSwift.DisposeBag = .init()

    let selectButton = UIButton().then {
        $0.setButton(image: .photoSelect)
    }

    func layout() {

        self.contentView.addSubview(selectButton)

        selectButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        self.disposeBag = DisposeBag()
    }

}
