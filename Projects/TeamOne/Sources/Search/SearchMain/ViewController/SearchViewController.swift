//
//  SearchViewController.swift
//  TeamOne
//
//  Created by Junyoung on 12/5/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class SearchViewController: ViewController {
    
    private let viewModel: SearchViewModel
    
    private let mainView = SearchMainView()
    
    private let deleteHistory = PublishSubject<String>()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    // MARK: - Inits
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        mainView.tableView.register(SearchHistoryCell.self,
                                    forCellReuseIdentifier: SearchHistoryCell.defaultReuseIdentifier)
    }
    
    override func bind() {
        
        let input = SearchViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in },
            searchHistoryInput: mainView.searchHeader.searchText,
            tapSearch: mainView.searchHeader.tapSearch,
            tapDeleteHistory: deleteHistory,
            tapClearAllHistory: mainView.recentSearchClearView.tapRecentHistoryClear,
            tapBack: mainView.searchHeader.tapBack,
            tapKeyword: mainView.tableView.rx.modelSelected(String.self).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.searchHistoryList
            .bind(to: mainView.tableView.rx.items(
                cellIdentifier: SearchHistoryCell.defaultReuseIdentifier,
                cellType: SearchHistoryCell.self)) { (row, element, cell) in
                    cell.bind(title: element)
                    
                    cell.deleteHistoryButton.rx.tap
                        .withUnretained(self)
                        .subscribe(onNext: { this, _ in
                            this.deleteHistory.onNext(cell.historyTitle)
                        })
                        .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.searchIsEmpty
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, isEmpty in
                this.mainView.isEmpty(isEmpty)
            })
            .disposed(by: disposeBag)
    }
}
