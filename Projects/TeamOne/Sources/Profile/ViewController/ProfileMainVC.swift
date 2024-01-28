//
//  ProfileMainVC.swift
//  TeamOne
//
//  Created by Junyoung on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class ProfileMainVC: ViewController {
    
    private let viewModel: ProfileMainViewModel
    
    private let mainView = ProfileMainView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Inits
    
    init(viewModel: ProfileMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = ProfileMainViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        mainView.myProjectView.myProjectType
            .subscribe(onNext: { type in
                print(type.toName)
            })
            .disposed(by: disposeBag)
    }
}
