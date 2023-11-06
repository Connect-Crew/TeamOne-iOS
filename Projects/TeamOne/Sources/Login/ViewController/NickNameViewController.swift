//
//  NickNameViewController.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class NickNameViewController: ViewController {

    // MARK: - Properties

    private let viewModel: NickNameViewModel

    private let mainView = NickNameView()
    
   

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
        // Set the navigation title in viewWillAppear
               self.title = "Your Title"
               
               // Optionally configure other navigation bar appearance settings
               if let navBar = self.navigationController?.navigationBar {
                   navBar.barTintColor = .black
                   navBar.tintColor = .black
                   navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black
                   ]
               }
        }
    // MARK: - Inits

    init(viewModel: NickNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    }



