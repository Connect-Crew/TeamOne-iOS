//
//  PhotoSelectCollectionView.swift
//  DSKit
//
//  Created by 강현준 on 12/12/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public struct DSImageWithName {
    public let name: String
    public let Image: UIImage
    
    public init(name: String, Image: UIImage) {
        self.name = name
        self.Image = Image
    }
}

public final class PhotoSelectCollectionView: UICollectionView {

    public var photos: [DSImageWithName] = [] {
        didSet {
            self.reloadData()
        }
    }

    private var height: CGFloat

    private var maxCount: Int

    public var onClickAddPhoto = PublishRelay<Void>()

    public var onClickDeletePhoto = PublishRelay<DSImageWithName>()

    private let disposeBag = DisposeBag()

    public init(height: CGFloat, maxCount: Int) {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: height, height: height)
        
        self.height = height
        self.maxCount = maxCount

        super.init(frame: .zero, collectionViewLayout: layout)

        setLayout()
        initSetting()
    }

    func setLayout() {
        self.backgroundColor = .clear

        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }

    func initSetting() {
        self.delegate = self
        self.dataSource = self
        self.register(BaseSelectButtonCell.self, forCellWithReuseIdentifier: BaseSelectButtonCell.identifier)
        self.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setImage(images: [DSImageWithName]) {
        self.photos = images
    }
}

extension PhotoSelectCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if photos.count < maxCount {
            return photos.count + 1
        } else {
            return photos.count
        }

    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row >= photos.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseSelectButtonCell.identifier, for: indexPath) as? BaseSelectButtonCell else { return UICollectionViewCell() }

            cell.layout()

            cell.selectButton.rx.tap
                .map { _ in return () }
                .bind(to: onClickAddPhoto)
                .disposed(by: cell.disposeBag)

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }

            let image = photos[indexPath.row]

            cell.layout()
            cell.setImage(image: image)
            
            cell.deleteButtonTapSubject
                .bind(to: onClickDeletePhoto)
                .disposed(by: cell.disposeBag)

            return cell
        }
    }
}

extension PhotoSelectCollectionView: UICollectionViewDelegate {

}
