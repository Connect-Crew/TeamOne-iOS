//
//  NotificationViewController.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class NotificationViewController: ViewController {
    
    private let viewModel: NotificationViewModel
    
    private let mainView = NotificationMainView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Inits
    
    init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = NotificationViewModel.Input()
        
        let output = viewModel.transform(input: input)
    }
}

