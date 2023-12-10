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
    
    private let mainView = SearchDetailMainView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
}