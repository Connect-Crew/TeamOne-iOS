//
//  IntroduceMainView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Core
import DSKit
import SnapKit
import Then
import UIKit
import Domain

final class IntroduceMainView: View {

    let imageSlider = ImageSlideView()

    let scrollView = UIScrollView().then {
        $0.backgroundColor = .teamOne.bgColor
    }

    let scrollViewContentView = UIView()

    let imageViewLocation = UIImageView().then {
        $0.image = .image(dsimage: .place)
    }

    let labelLocaion = UILabel().then {
        $0.setLabel(text: "지역", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let labelTime = UILabel().then {
        $0.textAlignment = .right
        $0.setLabel(text: "00분전", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let labelTitle = UILabel().then {
        $0.setLabel(text: "맛집지도앱 함께 제작하실 분들 구합니다", typo: .title1, color: .teamOne.grayscaleEight)
    }

    lazy var firstStackView = UIStackView(arrangedSubviews: [imageViewLocation, labelLocaion, UIView(), labelTime]).then {
        $0.axis = .horizontal
        $0.spacing = 2
    }

    lazy var hashtagListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HashtagFlowLayout()
    ).then {
        $0.register(HashTagCollectionViewCell.self, forCellWithReuseIdentifier: HashTagCollectionViewCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
    }

    let viewIntroduceLeader = IntroduceLeaderView()

    let viewRecuritStatus = IntroduceRecuritStatusView()

    let labelProjectIntroduce = UILabel().then {
        $0.setLabel(text: "프로젝트 소개", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let textView = UITextView().then {
        $0.isEditable = false
        $0.backgroundColor = .clear
    }

    let labelTechStack = UILabel().then {
        $0.setLabel(text: "기술 스택", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let viewTechStack = CellListStackView()

    lazy var contentView = UIStackView(arrangedSubviews: [
        firstStackView,
        labelTitle,
        hashtagListCollectionView,
        viewIntroduceLeader,
        viewRecuritStatus,
        labelProjectIntroduce,
        textView,
        labelTechStack,
        viewTechStack
    ]).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.setCustomSpacing(12, after: firstStackView)
        $0.setCustomSpacing(12, after: viewIntroduceLeader)
        $0.setCustomSpacing(12, after: viewRecuritStatus)
        $0.setCustomSpacing(24, after: textView)
    }

    var hashTags: [HashTag] = []

    let viewBottom = IntroduceBottomView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initHashTag(hashTags: [HashTag]) {
        self.hashTags = hashTags
        self.hashtagListCollectionView.reloadData()
    }

    private func layout() {

        addSubview(scrollView)

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        scrollView.addSubview(scrollViewContentView)

        scrollViewContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        scrollViewContentView.addSubview(imageSlider)

        imageSlider.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(172)
        }

        imageSlider.configure(with: [.image(dsimage: .defaultIntroduceImage),
                                     .image(dsimage: .defaultIntroduceImage),
                                     .image(dsimage: .defaultIntroduceImage),
                                     .image(dsimage: .defaultIntroduceImage)])

        scrollViewContentView.addSubview(contentView)

        addSubview(viewBottom)

        viewBottom.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.bottom.equalTo(viewBottom.snp.top)
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(imageSlider.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }


        hashtagListCollectionView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
    }
}

extension IntroduceMainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hashTags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = hashtagListCollectionView.dequeueReusableCell(
            withReuseIdentifier: HashTagCollectionViewCell.identifier, for: indexPath
        ) as? HashTagCollectionViewCell else {
            return UICollectionViewCell()
        }

        let hashTag = self.hashTags[indexPath.row]

        cell.initSetting(tag: hashTag)

        return cell
    }
}

extension IntroduceMainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let hashTags = hashTags[indexPath.row]

        let titleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.setLabel(text: hashTags.title, typo: .caption2, color: .teamOne.grayscaleSeven)
        }

        let width = titleLabel.intrinsicContentSize.width + 16
        let height = 17.0

        return CGSize(width: width, height: height)
    }
}
