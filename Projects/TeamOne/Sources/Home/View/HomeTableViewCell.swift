//
//  HomeTableViewCell.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import Domain

import RxSwift
import RxCocoa

final class HomeTableViewCell: UITableViewCell, CellIdentifiable {

    var disposeBag: DisposeBag = .init()

    var project: SideProject?

    // MARK: - Properties

    let containerView = UIView().then {
        $0.backgroundColor = .clear
    }

    let mainImageView: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.teamOne.grayscaleOne.cgColor
        $0.layer.borderWidth = 1
        $0.image = .image(dsimage: .logo)
    }

    let contentContainerView = UIView().then {
        $0.backgroundColor = .clear
    }

    let titleLabel = UILabel().then {
        $0.text = "배달비 없는 배달앱 - 함께 하실분구해요오오옷ㅌ"
        $0.font = .setFont(font: .button1)
    }

    let locationImageView = UIImageView().then {
        $0.image = .image(dsimage: .place)
    }

    let locationLabel = UILabel().then {
        $0.setLabel(text: "서울", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let locationDurationDivider = UILabel().then {
        $0.backgroundColor = .teamOne.grayscaleFive
    }

    let projectDurationLabel = UILabel().then {
        $0.setLabel(text: "2023.10.23 ~ 12.20", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let dropDownView = HomeDropDownView()

    let heartImageView = UIImageView().then {
        $0.image = .image(dsimage: .heartline)
    }

    let heartCountlabel = UILabel().then {
        $0.setLabel(text: "0", typo: .caption1, color: .teamOne.point)
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

    // MARK: - Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(project: SideProject) {

        self.project = project

        titleLabel.text = project.title

        locationLabel.text = project.location

        if project.isExistedperiod == true,
           let startDate = project.startDate,
           let endDate = project.endDate {
            projectDurationLabel.text = "\(startDate) ~ \(endDate)"
        } else {
            projectDurationLabel.text = "기간미정"
        }

        dropDownView.configure(project: project)

        if project.isEmpty == true {
            contentView.isHidden = true
        }

    }

    // MARK: - Methods

    func layout() {

        contentView.clipsToBounds = false

        contentView.backgroundColor = .teamOne.backgroundDefault
        contentView.layer.cornerRadius = 8

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
            $0.width.equalTo(120)
        }

        mainImageView.snp.contentCompressionResistanceVerticalPriority = 760

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
            $0.trailing.equalToSuperview()
        }

        contentContainerView.addSubview(locationImageView)

        locationImageView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.width.height.equalTo(16)
        }

        locationImageView.snp.contentHuggingHorizontalPriority = 750

        contentContainerView.addSubview(locationLabel)

        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(locationImageView.snp.trailing)
            $0.centerY.equalTo(locationImageView)
        }

        locationLabel.snp.contentHuggingHorizontalPriority = 750

        contentContainerView.addSubview(locationDurationDivider)

        locationDurationDivider.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(locationImageView)
            $0.height.equalTo(locationLabel)
            $0.width.equalTo(1)
        }

        locationDurationDivider.snp.contentHuggingHorizontalPriority = 750

        contentContainerView.addSubview(projectDurationLabel)

        projectDurationLabel.snp.makeConstraints {
            $0.leading.equalTo(locationDurationDivider.snp.trailing).offset(4)
            $0.centerY.equalTo(locationImageView)
            $0.trailing.equalToSuperview()
        }

        projectDurationLabel.snp.contentHuggingHorizontalPriority = 749.0

        contentContainerView.addSubview(hashtagListCollectionView)

        hashtagListCollectionView.snp.makeConstraints {
            $0.top.equalTo(locationImageView.snp.bottom).offset(14)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(38)
        }

        containerView.addSubview(heartCountlabel)

        heartCountlabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        containerView.addSubview(heartImageView)

        heartImageView.snp.makeConstraints {
            $0.trailing.equalTo(heartCountlabel.snp.leading)
            $0.centerY.equalTo(heartCountlabel)
            $0.width.equalTo(24)
        }

        containerView.addSubview(dropDownView)

        dropDownView.snp.makeConstraints {
            $0.top.equalTo(heartImageView)
            $0.trailing.equalTo(heartImageView.snp.leading).offset(-10)
        }
    }
}

extension HomeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        guard let hashTags = project?.hashTags else { return 0 }

        return hashTags.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = hashtagListCollectionView.dequeueReusableCell(
            withReuseIdentifier: HashTagCollectionViewCell.identifier, for: indexPath
        ) as? HashTagCollectionViewCell else {
            return UICollectionViewCell()
            
        }

        guard let hashTags = project?.hashTags else { return UICollectionViewCell() }

        cell.configure(hashTag: hashTags[indexPath.row])

        return cell
    }
}

extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let hashTags = project?.hashTags else {
            print("@@@@@ HomeTableViewCell: UICollectionViewDelegateFlowLayout ")
            return  CGSize(width: 0, height: 0) }

        let titleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.setLabel(text: hashTags[indexPath.row].title, typo: .caption2, color: .teamOne.grayscaleSeven)
        }

        let width = titleLabel.intrinsicContentSize.width + 16 
        let height = 17.0

        return CGSize(width: width, height: height)
    }
}
