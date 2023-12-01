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

    // MARK: - Properties

    private let viewModel: HomeViewModel

    private let mainView = HomeMainView()

    var tableView: UITableView {
        return mainView.tableView
    }

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

        tableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind() {
        let input = HomeViewModel.Input(
            viewDidAppear: rx.viewDidAppear.map { _ in return }.asObservable(),
            parts: mainView.selected,
            writeButtonTap: mainView.buttonWrite.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            participantsButtonTap: participantsButtonTap,
            likeButtonTap: likeButtonTap,
            didScrolledEnd: mainView.tableView.rx.reachedBottom
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            didSelectedCell: mainView.tableView.rx.itemSelected
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)

        bindHomeTableView(output: output)
    }

    func bindHomeTableView(output: HomeViewModel.Output) {

        output.projects
            .drive(tableView.rx.items) { tableView, index, project in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: HomeTableViewCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? HomeTableViewCell
                else {
                    return UITableViewCell()
                }

                cell.selectionStyle = .none
                cell.prepareForReuse()
                cell.initSetting(project: project)
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
            .disposed(by: disposeBag)

        output.isEmpty
            .drive(onNext: { [weak self] bool in
                self?.tableView.rx.isHidden.onNext(bool)
                self?.mainView.viewEmpty.rx.isHidden.onNext(!bool)
            })
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
