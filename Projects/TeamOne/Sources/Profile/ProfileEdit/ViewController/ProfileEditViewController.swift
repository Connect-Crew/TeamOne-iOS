//
//  ProfileEditViewController.swift
//  TeamOne
//
//  Created by 강창혁 on 2/24/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class ProfileEditViewController: ViewController {
    
    private let viewModel: ProfileEditViewModel
    
    private let mainView = ProfileEditMainView()
    
    // MARK: - Initilzer
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func bind() {
        
        let input = ProfileEditViewModel.Input(
            tapBackButton: mainView.navBar.backButttonTap,
            tapEditCompleteButton: mainView.navBar.completeButtonTap
        )
        
        let output = viewModel.transform(input: input)
    }
    
}
