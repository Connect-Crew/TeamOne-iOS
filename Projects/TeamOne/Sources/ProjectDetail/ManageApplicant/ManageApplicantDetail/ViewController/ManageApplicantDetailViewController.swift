//
//  ManageApplicantDetailViewController.swift
//  TeamOne
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import SnapKit
import DSKit
import Domain

final class ManageApplicantDetailViewController: ViewController {
    
    private let navigationBar = ManageApplicantDetailNavigationView()
    
    private let tableView = UITableView().then {
        $0.register(ManageApplicantDetailTableViewCell.self, forCellReuseIdentifier: ManageApplicantDetailTableViewCell.identifier)
        $0.backgroundColor = .clear
    }
    
    private let viewModel: ManageApplicantDetailViewModel
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    // MARK: - Inits
    
    init(viewModel: ManageApplicantDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        
        // navigationBar
        self.view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        let input = ManageApplicantDetailViewModel.Input(
            backButtonTap: navigationBar.backButtonTap
        )
        
        let output = viewModel.transform(input: input)
        
        output
            .sampleOutput
            .drive(tableView.rx.items(
                cellIdentifier: ManageApplicantDetailTableViewCell.identifier,
                cellType: ManageApplicantDetailTableViewCell.self)) { _, item, cell in
                    
                    
                }
                .disposed(by: disposeBag)
        
        bindNavigationBar()
    }
    
    private func bindNavigationBar() {
        navigationBar.initSetting(part: "UX / UI 디자이너")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.bringSubviewToFront(navigationBar)
        
        navigationBar.applyShadow(offsetX: 0, offsetY: 4, blurRadius: 8, color: UIColor(r: 158, g: 158, b: 158, a: 1), opacity: 0.3, positions: [.bottom])
    }
}

