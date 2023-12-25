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
    
    let contentView = UIView().then {
        $0.backgroundColor = .teamOne.background
    }
    let emptyView = HistoryEmptyView()
    
//    let searchTableView = UITableView().then {
//        $0.backgroundColor = .teamOne.background
//    }
//    
//    let searchResultTableView = UITableView().then {
//        $0.backgroundColor = .teamOne.background
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(containerStackView.snp.bottom)
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        isEmpty(true)
        
        searchHeader.setBaseShadow(radius: 8)
    }
    
    func applaySyle(_ type: SearchStyle) {
        switch type {
        case .before:
            recentSearchClearView.isHidden = false
        case .after:
            recentSearchClearView.isHidden = true
        }
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
