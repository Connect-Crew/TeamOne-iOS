//
//  HomeViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core

import RxSwift
import RxCocoa
import SnapKit
import Then

final class HomeViewController: ViewController {

    // MARK: - Properties

    let viewModel: HomeViewModel

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let zview = UIView()
        zview.frame = CGRect(x: 100, y: 100, width: 100, height: 300)
        zview.backgroundColor = .red
        view.addSubview(zview)
    }

    // MARK: - Inits

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
