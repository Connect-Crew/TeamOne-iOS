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

final class SearchMainView: UIView {
    
    let searchHeader = SearchHeaderView()
    let recentSearchClearContainer = UIStackView()
    let recentSearchClearView = RecentSearchClearView()
    let contentView = UIView()
    let emptyView = HistoryEmptyView()
    let tableView = UITableView()
    
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
        
        addSubview(recentSearchClearContainer)
        recentSearchClearContainer.addArrangedSubview(recentSearchClearView)
        recentSearchClearView.snp.makeConstraints { make in
            make.height.equalTo(53)
        }
        
        recentSearchClearContainer.snp.makeConstraints { make in
            make.top.equalTo(searchHeader.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchClearContainer.snp.bottom)
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.separatorStyle = .none
        
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
