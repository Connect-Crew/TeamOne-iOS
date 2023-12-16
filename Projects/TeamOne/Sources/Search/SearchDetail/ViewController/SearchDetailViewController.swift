//
//  SearchDetailViewController.swift
//  TeamOne
//
//  Created by Junyoung on 12/9/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class SearchDetailViewController: ViewController {
    
    private let viewModel: SearchDetailViewModel
    
    private let mainView = SearchMainView(type: .after)
    
    private let filterData = ProjectFilterType.allCases
    
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
    
    init(viewModel: SearchDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = SearchDetailViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in }
        )
        
        let output = viewModel.transform(input: input)
        
        output.searchResult
            .bind(to: mainView.searchResultTableView.rx.items(
                cellIdentifier: HomeTableViewCell.defaultReuseIdentifier,
                cellType: HomeTableViewCell.self)) { [weak self] (_, element, cell) in
                    guard let self = self else { return }
                    
                    cell.selectionStyle = .none
                    cell.prepareForReuse()
                    cell.initSetting(project: element)
                }
            .disposed(by: disposeBag)
    }
    
    func setup() {
        mainView.filterCollectionView.delegate = self
        mainView.filterCollectionView.dataSource = self
        mainView.filterCollectionView.register(SearchFilterCell.self, forCellWithReuseIdentifier: SearchFilterCell.defaultReuseIdentifier)
        mainView.filterCollectionView.reloadData()
        
        mainView.searchResultTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.defaultReuseIdentifier)
    }
}

extension SearchDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchFilterCell.defaultReuseIdentifier, for: indexPath) as! SearchFilterCell
        
        let item = filterData[indexPath.item]
        
        cell.bind(to: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filterData[indexPath.item]
        
        print(item.toString)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 해당 indexPath의 데이터를 가져오거나 계산
        let data = filterData[indexPath.item]

        // 셀 내부 요소에 따라 동적으로 예상 크기를 계산
        let estimatedSize = calculateEstimatedSize(for: data)

        // collectionView에 현재 그려질 셀의 크기를 설정
        (collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = estimatedSize
        
        return estimatedSize
    }
    
    func calculateEstimatedSize(for data: ProjectFilterType) -> CGSize {
        // data를 기반으로 셀 내부의 레이아웃을 설정하고, fittingSize를 계산
        let contentView = SearchFilterCell() // YourCell의 실제 콘텐츠 뷰
        contentView.bind(to: data)

        let fittingSize = contentView.systemLayoutSizeFitting(CGSize(width: UIView.layoutFittingCompressedSize.width, height: 24))

        // fittingSize에 필요한 여백 등을 추가하여 반환
        let padding: CGFloat = 0
        let estimatedSize = CGSize(width: fittingSize.width + padding, height: fittingSize.height)

        return estimatedSize
    }
}
