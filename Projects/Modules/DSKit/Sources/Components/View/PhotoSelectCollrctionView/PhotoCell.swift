//
//  PhotoCell.swift
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

public final class PhotoCell: UICollectionViewCell, CellIdentifiable {

    public var disposeBag: RxSwift.DisposeBag = .init()

    private var image: UIImage?

    public var deleteButtonTapSubject = PublishSubject<UIImage>()

    let imageView = UIImageView().then {
        $0.backgroundColor = .systemGray2
    }

    let deleteButton = UIButton().then {
        $0.setButton(image: .delete3)
    }

    func layout() {

        self.contentView.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.contentView.addSubview(deleteButton)

        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalTo(imageView)
        }
        
        bind()
    }

    func setImage(image: UIImage) {
        self.imageView.image = image
        self.image = image
    }

    func bind() {
        deleteButton.rx.tap
            .withUnretained(self)
            .map { cell, _ in
                return cell.image
            }
            .compactMap { $0 }
            .bind(to: deleteButtonTapSubject)
            .disposed(by: disposeBag)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

}
