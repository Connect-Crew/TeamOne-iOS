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
import SnapKit
import DSKit

import RxSwift
import RxCocoa

final class HomeTableViewCell: UITableViewCell, CellIdentifiable {

    var disposeBag: DisposeBag = .init()

    // MARK: - Properties

    let viewContainer = UIView().then {
        $0.backgroundColor = .clear
    }

    let imageViewMain: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.image = .image(dsimage: .logo)
    }

    let viewIsNew = ViewBGImage_Label(bgImage: .newTagBG, text: "NEW", font: .caption2, textColor: .white)

    let labelTitle = UILabel().then {
        $0.setLabel(text: "배달비 없는 배달앱 - 함께 하실분구해요오오옷ㅌ", typo: .body4, color: .teamOne.grayscaleEight)
    }

    let imageViewLocation = UIImageView().then {
        $0.image = .image(dsimage: .place)
    }

    let labelLocation = UILabel().then {
        $0.setLabel(text: "서울", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let viewLocationDivider = UILabel().then {
        $0.setLabel(text: "ㅣ", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let labelUploadTime = UILabel().then {
        $0.setLabel(text: "방금 전", typo: .caption2, color: .teamOne.grayscaleSeven)
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

    let buttonParticipants = Button_IsEnabledImage(
        text: "0/0", typo: .caption1,
        enabledImage: .count, disabledImage: .countDisable,
        enabledTextColor: .teamOne.mainColor, disabledTextColor: .teamOne.grayscaleFive)

    let buttonLike = Button_IsLiked(count: 0, typo: .caption1, isLiked: false, likedImage: .heartsolid, unLikedImage: .heartline, likedTextColor: .teamOne.point)

    lazy var contentStackView = UIStackView(
        arrangedSubviews: [
            createFirstHorizontalStackView(),
            createSecondButtonStackView()
        ]
    ).then {
        $0.axis = .vertical
        $0.distribution = .fill
    }

    private var project: SideProjectListElement?

    private var buttonParticipatsTapSubject = PublishSubject<SideProjectListElement?>()
    private var buttonLikeTapSubject = PublishSubject<SideProjectListElement?>()

    var buttonParticipantsTap: Observable<SideProjectListElement?> {
        return buttonParticipatsTapSubject.asObservable()
    }

    var buttonLikeTap: Observable<SideProjectListElement?> {
        return buttonLikeTapSubject.asObservable()
    }

    // MARK: - Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.disposeBag = DisposeBag()
    }

    func initSetting(project: SideProjectListElement) {

        self.project = project

        self.labelTitle.text = project.title

        if project.online == true {
            self.labelLocation.text = "온라인"
        } else {
            self.labelLocation.text = project.region
        }

        viewIsNew.isHidden = !project.region.isNewData()
        labelUploadTime.text = project.createdAt.toRelativeDateString()

        var totalMemberCnt: Int = 0
        var currentMemberCnt: Int = 0

        project.recruitStatus.forEach {
            totalMemberCnt += $0.max
            currentMemberCnt += $0.current
        }

        buttonParticipants.setTitle("\(currentMemberCnt)/\(totalMemberCnt)", for: .normal)

        buttonLike.likedCount = project.favorite

        buttonLike.isLiked = project.myFavorite
    }

    // MARK: - Methods

    func layout() {

        contentView.backgroundColor = .clear

        contentView.addSubview(viewContainer)

        viewContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(10)
        }

        viewContainer.layer.cornerRadius = 8

        viewContainer.backgroundColor = .white
        viewContainer.layer.masksToBounds = false
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOpacity = 0.2
        viewContainer.layer.shadowRadius = 8
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 0)

        viewContainer.addSubview(contentStackView)

        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        viewContainer.addSubview(viewIsNew)

        viewIsNew.snp.makeConstraints {
            $0.top.left.equalTo(imageViewMain)
        }
    }

    func createFirstHorizontalStackView() -> UIStackView {

        let locationInformationStackView = UIStackView(arrangedSubviews: [
            imageViewLocation,
            labelLocation,
            viewLocationDivider,
            labelUploadTime,
            UIView()
        ]
        ).then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 4
        }

        imageViewLocation.snp.makeConstraints {
            $0.width.height.equalTo(16).priority(.required)
        }

        labelLocation.snp.contentHuggingHorizontalPriority = 750
        labelUploadTime.snp.contentHuggingHorizontalPriority = 749

        let verticalStackView = UIStackView(arrangedSubviews: [labelTitle, locationInformationStackView, hashtagListCollectionView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .fill

        let stackView = UIStackView(arrangedSubviews: [imageViewMain, verticalStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8

        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 8, right: 10)

        stackView.isLayoutMarginsRelativeArrangement = true

        imageViewMain.snp.makeConstraints {
            $0.width.height.equalTo(100).priority(.required)
        }

        return stackView
    }

    func createSecondButtonStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonParticipants, buttonLike])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually

        [buttonParticipants, buttonLike].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(44)
            }
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.teamOne.grayscaleTwo.cgColor
            $0.isEnabled = true
        }

        buttonParticipants.addTarget(self, action: #selector(buttonParticipatnsTapped), for: .touchUpInside)
        buttonLike.addTarget(self, action: #selector(buttonLikeTapped), for: .touchUpInside)

        return stackView
    }

    @objc private func buttonParticipatnsTapped() {
        buttonParticipatsTapSubject.onNext(project)
    }

    @objc private func buttonLikeTapped() {
        buttonLikeTapSubject.onNext(project)
    }
}

extension HomeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        guard let hashTags = self.project?.HashTags else { return 0 }

        return hashTags.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = hashtagListCollectionView.dequeueReusableCell(
            withReuseIdentifier: HashTagCollectionViewCell.identifier, for: indexPath
        ) as? HashTagCollectionViewCell,
              let hashTag = project?.HashTags[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = hashTag.title

        switch hashTag.titleColor {
        case .gray:
            cell.titleLabel.textColor = .teamOne.grayscaleSeven
        }

        switch hashTag.background {
        case .gray:
            cell.backgroundImageView.image = .image(dsimage: .tagGray)
        case .pink:
            cell.backgroundImageView.image = .image(dsimage: .tagRed)
        }

        return cell
    }
}

extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let hashTags = project?.HashTags[indexPath.row] else {
            print("@@@@@ HomeTableViewCell: UICollectionViewDelegateFlowLayout ")
            return  CGSize(width: 0, height: 0) }

        let titleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.setLabel(text: hashTags.title, typo: .caption2, color: .teamOne.grayscaleSeven)
        }

        let width = titleLabel.intrinsicContentSize.width + 16
        let height = 17.0

        return CGSize(width: width, height: height)
    }
}
