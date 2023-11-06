//
//  TosViewController.swift
//  TeamOne
//
//  Created by 임재현 on 2023/11/01.
//  Copyright © 2023 TeamOne. All rights reserved.
//
import Foundation
import UIKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class TosViewController: ViewController {
    // MARK: - Properties
    
    private let viewModel: TosViewModel
    
    private let mainView = TosView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Your Title"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - Inits
    
    init(viewModel: TosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
}



