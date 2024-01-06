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
import Domain

final class SearchViewController: ViewController {
    
    private enum Section: Int, CaseIterable {
        case history
        case result
    }
    
    private var searchItems = [String]()
    private var resultItems = [SideProjectListElement]()
    
    enum Item: Hashable {
        case history(String)
        case result(SideProjectListElement)
        
    }
    
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let viewModel: SearchViewModel
    
    private let mainView = SearchMainView()
    
    private let deleteHistory = PublishSubject<String>()
    private let historySelected = PublishSubject<String>()
    private let projectSeleted = PublishSubject<SideProjectListElement>()
    
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
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .teamOne.background
        collectionView.register(SearchHistoryCell.self, forCellWithReuseIdentifier: SearchHistoryCell.defaultReuseIdentifier)
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.defaultReuseIdentifier)
        collectionView.delegate = self
        
        mainView.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView, 
                                                                       cellProvider: { [weak self] collectionView, indexPath, item in
            guard let this = self else { return nil }
            return this.createCell(for: item, indexPath: indexPath, collectionView: collectionView)
        })
    }
    
    func createCell(for item: Item, indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell? {
        switch item {
        case .history(let history):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryCell.defaultReuseIdentifier, for: indexPath) as! SearchHistoryCell
            cell.configure(history)
            
            cell.deleteHistoryButton.rx.tap
                .map { cell.historyLabel.text ?? "" }
                .bind(to: deleteHistory)
                .disposed(by: cell.disposeBag)
            
            return cell
        case .result(let project):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.defaultReuseIdentifier, for: indexPath) as! HomeCell
            cell.initSetting(project: project)
            return cell
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            switch sectionKind {
            case .history:
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            case .result:
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 28, leading: 0, bottom: 0, trailing: 0)
            }
            return section
        }
        
        return layout
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let sectionItems = Section.allCases
        
        snapshot.appendSections(sectionItems)
        
        sectionItems.forEach {
            switch $0 {
            case .history:
                snapshot.appendItems(searchItems.map { Item.history($0) }, toSection: .history)
            case .result:
                snapshot.appendItems(resultItems.map { Item.result($0) }, toSection: .result)
            }
        }
        
        self.dataSource.apply(snapshot)
    }
    
    private func updateSnapshotFor(_ sectionToShow: Section) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let sectionItems = Section.allCases
        snapshot.appendSections(sectionItems)
        
        switch sectionToShow {
        case .history:
            snapshot.appendItems(searchItems.map { Item.history($0) }, toSection: .history)
        case .result:
            snapshot.appendItems(resultItems.map { Item.result($0) }, toSection: .result)
        }
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
            tapKeyword: historySelected,
            tapProject: projectSeleted
        )
        
        let output = viewModel.transform(input: input)
        
        output.searchHistoryList
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                this.searchItems = result
                this.updateSnapshotFor(.history)
            })
            .disposed(by: disposeBag)
        
        output.searchIsEmpty
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, isEmpty in
                this.mainView.isEmpty(isEmpty)
                this.collectionView.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
        
        output.searchResult
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                this.mainView.applaySyle(.after)
                
                this.resultItems = result
                this.updateSnapshotFor(.result)
            })
            .disposed(by: disposeBag)
        
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
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .history(let data):
            historySelected.onNext(data)
        case .result(let data):
            projectSeleted.onNext(data)
        }
        
    }
}
