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
        let input = SearchDetailViewModel.Input()
        
        let output = viewModel.transform(input: input)
    }
    
    func setup() {
        mainView.filterCollectionView.delegate = self
        mainView.filterCollectionView.dataSource = self
        mainView.filterCollectionView.register(SearchFilterCell.self, forCellWithReuseIdentifier: SearchFilterCell.defaultReuseIdentifier)
        mainView.filterCollectionView.reloadData()
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
        
        return CGSize(width: 80, height: 24)
    }
}
