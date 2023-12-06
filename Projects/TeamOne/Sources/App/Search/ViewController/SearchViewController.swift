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
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Inits
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = SearchViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        mainView.searchHeader.tapBack
            .subscribe(onNext: { _ in
                print("tap Back")
            })
            .disposed(by: disposeBag)
        
        mainView.searchHeader.tapSearch
            .subscribe(onNext: { _ in
                print("Tap Search")
            })
            .disposed(by: disposeBag)
    }
}
