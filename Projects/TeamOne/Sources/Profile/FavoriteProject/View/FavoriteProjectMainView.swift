//
//  FavoriteProjectMainView.swift
//  TeamOne
//
//  Created by 강현준 on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class FavoriteProjectMainView: View {
    
    private let navBar = FavoriteProjectNavBar()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout()).then {
        $0.register(FavoriteProjectCell.self)
    }
    
    var backButtonTap: Observable<Void> {
        return navBar.backButttonTap
    }
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutNavBar()
        layoutCollectionView()
    }
    
    private func layoutNavBar() {
        addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(91)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: itemSize.heightDimension
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 12
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
