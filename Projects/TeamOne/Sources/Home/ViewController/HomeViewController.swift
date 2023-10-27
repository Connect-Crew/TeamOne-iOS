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

    private let mainView = HomeView()

    var homeTableView: UITableView {
        return mainView.homeTableView
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

//        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Inits

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        mainView.homeTableView.dataSource = self
        mainView.homeTableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        158
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let remainTopSpacingoffset = -homeTableView.contentOffset.y - mainView.headerMinHeight

        print("remainTopSpacingoffset: \(remainTopSpacingoffset)")

        print("headerMinHeight: \(mainView.headerMinHeight)")
        print("headerMaxHeight: \(mainView.headerMaxHeight)")

        if remainTopSpacingoffset < mainView.headerMaxHeight {
            mainView.goToSeeProjectView.snp.updateConstraints {
                $0.height.equalTo(remainTopSpacingoffset)
            }
        } else {
            mainView.goToSeeProjectView.snp.updateConstraints {
                $0.height.equalTo(remainTopSpacingoffset)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeTableView.dequeueReusableCell(
            withIdentifier: HomeTableViewCell.identifier,
            for: indexPath
        ) as? HomeTableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none

        return cell
    }
}
