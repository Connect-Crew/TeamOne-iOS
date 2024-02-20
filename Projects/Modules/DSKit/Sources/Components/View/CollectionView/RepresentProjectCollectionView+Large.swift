//
//  RepresentProjectCollectionView+Large.swift
//  DSKit
//
//  Created by 강현준 on 2/14/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import Core
import SnapKit

public final class RepresentProjectCollectionView_Large: UICollectionView {
    
    public static let cellheight: CGFloat = 187
    public static let lineSpacing: CGFloat = 20
    public static let itemSpacing: CGFloat = 20
    
    private var projects: [DSRepresentProject_Detail] = [] {
        didSet {
            setIsEmpty(isEmpty: projects.isEmpty)
            reloadData()
        }
    }
    
    public let emptyLabel = UILabel().then {
        $0.setLabel(text: "대표 프로젝트가 아직 없습니다.", typo: .caption2, color: .teamOne.grayscaleSeven)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    /// 셀 선택시 해당 릴레이로 이벤트 전달됩니다.
    public let didSelectCell = PublishRelay<IndexPath>()
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: Self.makeLayout())
        self.register(DSRepresentProjectLargeCell.self)
        initSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 해당 메서드로 대표프로젝트를 설정합니다.
    public func setProjects(projects: [DSRepresentProject_Detail]) {
        self.projects = projects
    }
    
    private func initSetting() {
        self.register(DSRepresentProjectLargeCell.self)
        layoutEmptyView()
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
        self.isScrollEnabled = false
    }
    
    private func layoutEmptyView() {
        self.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setIsEmpty(isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // 셀 크기 설정: 너비는 컨테이너의 1/2, 높이는 자유롭게 설정
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .estimated(Self.cellheight)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2
            )
            
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(Self.itemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        return layout
    }
}

extension RepresentProjectCollectionView_Large: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(DSRepresentProjectLargeCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension RepresentProjectCollectionView_Large: UICollectionViewDelegate {
    
}

final class DSRepresentProjectLargeCell: UICollectionViewCell {
    
    private let thumbnailImageView = UIImageView().then {
        $0.image = .image(dsimage: .ralo)
        $0.contentMode = .scaleAspectFill
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabel(text: "타이틀 라벨", typo: .body4, color: .grayscaleEight)
    }
    
    private let periodLabel = UILabel().then {
        $0.setLabel(text: "0000.00.00 ~ 0000.00.00", typo: .caption2, color: .grayscaleFive)
    }
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        periodLabel
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 4
        $0.axis = .vertical
        $0.backgroundColor = .white
    }
    
    private let stackViewContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        stackViewContainer.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(67)
        }
        
        contentView.addSubview(stackViewContainer)
        stackViewContainer.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
        thumbnailImageView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.clipsToBounds = true
        
        stackViewContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        stackViewContainer.layer.masksToBounds = true
        stackViewContainer.clipsToBounds = true
        
        contentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        contentView.backgroundColor = .clear
        contentView.setBaseShadow(radius: 8)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = .image(dsimage: .logo)
    }
}
