//
//  FavoriteProjectVC.swift
//  TeamOne
//
//  Created by 강현준 on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit

final class FavoriteProjectVC: ViewController {
    
    private let viewModel: FavoriteProjectViewModel
    
    private let mainView = FavoriteProjectMainView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainView.collectionView.dataSource = self
    }
    
    // MARK: - Inits
    
    init(viewModel: FavoriteProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = FavoriteProjectViewModel.Input(
            backButtonTap: mainView.backButtonTap
        )
        
        let output = viewModel.transform(input: input)
    }
}

extension FavoriteProjectVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueCell(FavoriteProjectCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    
}
