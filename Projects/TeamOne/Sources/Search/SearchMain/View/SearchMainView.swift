//
//  SearchMainView.swift
//  TeamOne
//
//  Created by Junyoung on 12/5/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

public enum SearchStyle {
    case before
    case after
}

final class SearchMainView: UIView {
    
    let searchHeader = SearchHeaderView()
    
    let containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    let recentSearchClearView = RecentSearchClearView().then {
        $0.backgroundColor = .teamOne.background
    }
    
    let activeItemsView = ActiveItemsView().then {
        $0.backgroundColor = .teamOne.background
    }
    
    private let filterContainerView = UIView()
    
    let filterCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()
    
    private let contentView = UIView().then {
        $0.backgroundColor = .teamOne.background
    }
    let emptyView = HistoryEmptyView()
    
    let searchTableView = UITableView().then {
        $0.backgroundColor = .teamOne.background
    }
    
    let searchResultTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: SearchStyle) {
        self.init(frame: .zero)
        
        switch type {
        case .before:
            filterContainerView.isHidden = true
            recentSearchClearView.isHidden = false
            activeItemsView.isHidden = true
            searchTableView.isHidden = false
            searchResultTableView.isHidden = true
        case .after:
            filterContainerView.isHidden = false
            recentSearchClearView.isHidden = true
            activeItemsView.isHidden = false
            searchTableView.isHidden = true
            searchResultTableView.isHidden = false
        }
        
    }
    
    private func layout() {
        addSubview(searchHeader)
        searchHeader.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(42)
        }
        
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(searchHeader.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        containerStackView.addArrangedSubview(recentSearchClearView)
        recentSearchClearView.snp.makeConstraints { make in
            make.height.equalTo(53)
        }
        
        filterContainerView.addSubview(filterCollectionView)
        filterCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(24)
        }
        
        containerStackView.addArrangedSubview(filterContainerView)
        filterContainerView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        containerStackView.addArrangedSubview(activeItemsView)
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(containerStackView.snp.bottom)
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.addSubview(searchTableView)
        searchTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(searchResultTableView)
        searchResultTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchTableView.separatorStyle = .none
        searchResultTableView.separatorStyle = .none
        
        isEmpty(false)
    }
    
    func isEmpty(_ empty: Bool) {
        if empty {
            emptyView.isHidden = false
            recentSearchClearView.isHidden = true
        } else {
            emptyView.isHidden = true
            recentSearchClearView.isHidden = false
        }
    }
}
