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
        let input = FavoriteProjectViewModel.Input()
        
        let output = viewModel.transform(input: input)
    }
}

