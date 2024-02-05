//
//  RepresentProjectCollectionView.swift
//  DSKit
//
//  Created by 강현준 on 2/5/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import Core
import SnapKit

/// 대표프로젝트 설정하는 컬렉션뷰
/// width, height를 설정해야합니다.
public final class RepresentProjectCollectionView: UICollectionView {
    
    private var projects: [DSRepresentProject] = [] {
        didSet {
            setIsEmpty(isEmpty: projects.isEmpty)
            reloadData()
        }
    }
    
    public let emptyLabel = UILabel().then {
        $0.setLabel(text: "대표 프로젝트가 아직 없습니다.", typo: .caption2, color: .teamOne.grayscaleSeven)
        $0.textAlignment = .center
    }
    
    /// 셀 선택시 해당 릴레이로 이벤트 전달됩니다.
    public let didSelectCell = PublishRelay<DSRepresentProject>()
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: Self.makeLayout())
        initSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 해당 메서드로 대표프로젝트를 설정합니다.
    public func setProjects(projects: [DSRepresentProject]) {
        self.projects = projects
    }
    
    private func initSetting() {
        self.register(RepresentProjectCell.self)
        layoutEmptyView()
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        self.setRound(radius: 4)
    }
    
    private func layoutEmptyView() {
        self.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setIsEmpty(isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
        
        if isEmpty {
            backgroundColor = .teamOne.grayscaleTwo
        } else {
            backgroundColor = .teamOne.white
        }
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 3
            )
            
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(16)

            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        return layout
    }
}

extension RepresentProjectCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(RepresentProjectCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        let project = projects[indexPath.row]
        
        cell.setProject(project: project)
        cell.contentView.backgroundColor = .red
        cell.representImageViewTap
            .bind(to: didSelectCell)
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

extension RepresentProjectCollectionView: UICollectionViewDelegate {
    
}
