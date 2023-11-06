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

    private let viewModel: HomeViewModel

    private let mainView = HomeMainView()

    var tableView: UITableView {
        return mainView.tableView
    }

    // MARK: - LifeCycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        let input = HomeViewModel.Input()

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
                cell.config(project: project)

                return cell
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let baseHeight: CGFloat = 158

        return baseHeight
    }


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
