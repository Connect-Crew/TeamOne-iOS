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
    
    private enum Section {
        case main
    }
    
    private var searchItems = [String]()
    
    typealias Item = String
    
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    
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
        mainView.applaySyle(.before)
        
        mainView.searchTableView.register(SearchHistoryCell.self,
                                    forCellReuseIdentifier: SearchHistoryCell.defaultReuseIdentifier)
        
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: self.mainView.searchTableView) { [weak self]
            (tableView, indexPath, item) -> SearchHistoryCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryCell.defaultReuseIdentifier,
                                                           for: indexPath) as? SearchHistoryCell else { return nil }
            guard let this = self else { return nil }
            cell.bind(title: item)
            
            cell.deleteHistoryButton.rx.tap
                .withUnretained(this)
                .subscribe(onNext: { this, _ in
                    this.deleteHistory.onNext(cell.historyTitle)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
        
        applySnapshot()
        
        mainView.searchResultTableView.register(HomeTableViewCell.self,
                                                forCellReuseIdentifier: HomeTableViewCell.defaultReuseIdentifier)
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(searchItems, toSection: .main)
        self.dataSource.apply(snapshot)
    }
    
    override func bind() {
        
        let input = SearchViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in },
            searchHistoryInput: mainView.searchHeader.searchText,
            tapSearch: mainView.searchHeader.tapSearch,
            tapDeleteHistory: deleteHistory,
            tapClearAllHistory: mainView.recentSearchClearView.tapRecentHistoryClear,
            tapBack: mainView.searchHeader.tapBack,
            tapKeyword: mainView.searchTableView.rx.modelSelected(String.self).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.searchHistoryList
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                this.searchItems = result
                this.applySnapshot()
            })
            .disposed(by: disposeBag)
        
//            .bind(to: mainView.searchTableView.rx.items(
//                cellIdentifier: SearchHistoryCell.defaultReuseIdentifier,
//                cellType: SearchHistoryCell.self)) { [weak self] (_, element, cell) in
//                    guard let self = self else { return }
//                    
//                    cell.bind(title: element)
//                    
//                    cell.deleteHistoryButton.rx.tap
//                        .withUnretained(self)
//                        .subscribe(onNext: { this, _ in
//                            this.deleteHistory.onNext(cell.historyTitle)
//                        })
//                        .disposed(by: cell.disposeBag)
//            }
//            .disposed(by: disposeBag)
        
        output.searchIsEmpty
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, isEmpty in
                this.mainView.isEmpty(isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.searchResult
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.mainView.applaySyle(.after)
            })
            .disposed(by: disposeBag)
        
        output.searchResult
            .bind(to: mainView.searchResultTableView.rx.items(
                cellIdentifier: HomeTableViewCell.defaultReuseIdentifier,
                cellType: HomeTableViewCell.self)) { [weak self] (_, element, cell) in
                    cell.selectionStyle = .none
                    cell.prepareForReuse()
                    cell.backgroundColor = .teamOne.background
                    cell.initSetting(project: element)
                }
            .disposed(by: disposeBag)
    }
}
