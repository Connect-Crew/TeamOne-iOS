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
import DSKit

final class SearchViewController: ViewController {
    
    private enum Section {
        case main
    }
    
    private var searchItems = [String]()
    
    typealias Item = String
    
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let viewModel: SearchViewModel
    
    private let mainView = SearchMainView()
    
    private let deleteHistory = PublishSubject<String>()
    private let modelSelected = PublishSubject<String>()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColectionView()
        applySnapshot()
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
    }
    
    private func setupColectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.backgroundColor = .teamOne.background
        collectionView.register(SearchHistoryCell.self, forCellWithReuseIdentifier: SearchHistoryCell.defaultReuseIdentifier)
        collectionView.delegate = self
        
        mainView.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView, 
                                                                       cellProvider: { [weak self] collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryCell.defaultReuseIdentifier, for: indexPath) as? SearchHistoryCell else { return nil }
            guard let this = self else { return nil }
            cell.bind(title: item)
            
            cell.deleteHistoryButton.rx.tap
                .withUnretained(this)
                .subscribe(onNext: { this, _ in
                    this.deleteHistory.onNext(cell.historyTitle)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        })
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func applySnapshot() {
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
            tapKeyword: modelSelected
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
                this.collectionView.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
        
//        output.searchResult
//            .observe(on: MainScheduler.instance)
//            .withUnretained(self)
//            .subscribe(onNext: { this, _ in
//                this.mainView.applaySyle(.after)
//            })
//            .disposed(by: disposeBag)
        
//        output.searchResult
//            .bind(to: mainView.searchResultTableView.rx.items(
//                cellIdentifier: HomeTableViewCell.defaultReuseIdentifier,
//                cellType: HomeTableViewCell.self)) { [weak self] (_, element, cell) in
//                    cell.selectionStyle = .none
//                    cell.prepareForReuse()
//                    cell.backgroundColor = .teamOne.background
//                    cell.initSetting(project: element)
//                }
//            .disposed(by: disposeBag)
    }
}
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let title = self.dataSource.itemIdentifier(for: indexPath) else { return }
        modelSelected.onNext(title)
    }
}
