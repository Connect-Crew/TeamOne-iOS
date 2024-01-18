//
//  HomeViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import Domain

import RxSwift
import RxCocoa
import SnapKit
import Then

final class HomeViewController: ViewController {
    
    
    private enum Section: Int, CaseIterable {
        case list
    }
    
    private enum Item: Hashable {
        case result(SideProjectListElement)
    }
    
    private var list: [SideProjectListElement] = []

    // MARK: - Properties

    private let viewModel: HomeViewModel

    private let mainView = HomeMainView()

    var tableView: UITableView {
        return mainView.tableView
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!

    let participantsButtonTap = PublishSubject<SideProjectListElement?>()
    let likeButtonTap = PublishSubject<SideProjectListElement?>()

    // MARK: - LifeCycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Inits

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupTableView()
        tableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind() {
        let input = HomeViewModel.Input(
            viewDidLoad: rx.viewWillAppear.take(1).map { _ in return }.asObservable(),
            parts: mainView.selected,
            writeButtonTap: mainView.buttonWrite.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            participantsButtonTap: participantsButtonTap.throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            likeButtonTap: likeButtonTap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            didScrolledEnd: mainView.tableView.rx.reachedBottom
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            didSelectedCell: mainView.tableView.rx.itemSelected
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            tapSearch: mainView.searchButton.rx.tap.asObservable()
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)

        bindHomeTableView(output: output)
        bindError(output: output)
        mainView.bindIsEmptyView(isEmpty: output.projects.map { $0.isEmpty }.asObservable() )
    }
    
    private func setupTableView() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell,
                  case .result(let item) = item else {
                return UITableViewCell()
            }
            
            cell.prepareForReuse()
            cell.initSetting(project: item)
            cell.selectionStyle = .none
            cell.buttonParticipantsTap
                .subscribe(onNext: { [weak self]  in
                    self?.participantsButtonTap.onNext($0)
                })
                .disposed(by: cell.disposeBag)

            cell.buttonLikeTap
                .subscribe(onNext: { [weak self]  in
                    self?.likeButtonTap.onNext($0)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
            
        }
        
        tableView.dataSource = dataSource
    }
    
    private func applySnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        let sectionItems = Section.list
        
        snapshot.appendSections([sectionItems])
        
        snapshot.appendItems(list.map {
            Item.result($0)
        }, toSection: .list)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func bindHomeTableView(output: HomeViewModel.Output) {

        output.projects
            .drive(onNext: { [weak self] list in
                self?.list = list
                self?.applySnapShot()
            })
            .disposed(by: disposeBag)
    }
    
    func bindError(output: HomeViewModel.Output) {
        output.error
            .bind(to: rx.presentErrorAlert)
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let remainTopSpacingoffset = -tableView.contentOffset.y - mainView.headerMinHeight

        let remainTopRatio = remainTopSpacingoffset / mainView.headerViewWillDissmissHeight

        mainView.headerImageView.alpha = remainTopRatio

        if remainTopSpacingoffset < mainView.headerMaxHeight {
            mainView.headerImageView.snp.updateConstraints {
                $0.height.equalTo(remainTopSpacingoffset)
            }
        } else {
            mainView.headerImageView.snp.updateConstraints {
                $0.height.equalTo(remainTopSpacingoffset)
            }
        }

    }
}
