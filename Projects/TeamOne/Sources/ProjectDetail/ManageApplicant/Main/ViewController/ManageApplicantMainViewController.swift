//
//  ManageApplicantViewController.swift
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
import DSKit
import SnapKit
import Domain

final class ManageApplicantMainViewController: ViewController {
    
    // MARK: - UI
    
    private let navigationBar = ManageApplicantNavigationView()
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        $0.backgroundColor = .teamOne.background
        $0.register(ManageApplicantMainTableViewCell.self, forCellReuseIdentifier: ManageApplicantMainTableViewCell.identifier)
    }
    
    // MARK: - ViewModel
    
    private let viewModel: ManageApplicantMainViewModel
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Inits
    
    init(viewModel: ManageApplicantMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        
        self.view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

    }
    
    override func bind() {
        let input = ManageApplicantMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in () },
            backButtonTap: navigationBar.backButtonTap,
            didSelectCell: tableView.rx.itemSelected
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
        )
        
        let output = viewModel.transform(input: input)
        
        bindTableView(applyList: output.applyStatusList)
    }
    
    private func bindTableView(applyList: Driver<[ApplyStatus]>) {
        
        applyList
            .drive(tableView.rx.items(
                cellIdentifier: ManageApplicantMainTableViewCell.identifier,
                cellType: ManageApplicantMainTableViewCell.self
            )) { (_, status, cell) in
                
                let data = DSManageApplicantMainTableViewCellData(
                    part: status.part,
                    partKey: status.partKey,
                    category: status.category,
                    comment: status.comment,
                    current: status.current,
                    max: status.max,
                    isQuotaFull: status.isQuotaFull
                )

                cell.initSetting(data: data)
                
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.bringSubviewToFront(navigationBar)
        
        navigationBar.applyShadow(offsetX: 0, offsetY: 4, blurRadius: 8, color: UIColor(r: 158, g: 158, b: 158, a: 1), opacity: 0.3, positions: [.bottom])
    }
}
