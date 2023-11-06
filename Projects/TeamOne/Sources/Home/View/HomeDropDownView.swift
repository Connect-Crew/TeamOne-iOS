//
//  HomeDropDownView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

import Domain

import RxSwift
import RxCocoa

final class HomeDropDownView: UIView {

    private let disposeBag = DisposeBag()

    public var isSelected = BehaviorRelay<Bool>(value: false)

    private var project: SideProject?

    private let frontView = UIView()

    private let countImageView = UIImageView().then {
        $0.image = .image(dsimage: .count)
    }

    private let statusLabel = UILabel().then {
        $0.setLabel(text: "0/0", typo: .caption1, color: .teamOne.mainBlue)
    }

    private let upDownButton = UIButton().then {
        $0.setButton(image: .downTow)
    }

    private lazy var tableView = UITableView().then {
        $0.register(HomeDropDownTableViewCell.self, forCellReuseIdentifier: HomeDropDownTableViewCell.identifier)
        $0.backgroundColor = .white
        $0.dataSource = self
        $0.delegate = self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8

        setLayout()
        bind()
    }

    public func configure(project: SideProject?) {

        guard let project = project else { return }

        self.project = project
        self.statusLabel.text = "\(project.currentTeamMember)/\(project.totalTeamMember)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelect() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.teamOne.grayscaleOne.cgColor

        tableView.snp.updateConstraints {
            $0.height.equalTo(100)
        }
    }

    func setNoneSelect() {
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.clear.cgColor

        tableView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }

    func bind() {

        upDownButton.rx.tap
            .withLatestFrom(isSelected)
            .distinctUntilChanged()
            .map {
                return !$0
            }
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isSelected.accept($0)
            })
            .disposed(by: disposeBag)

        isSelected
            .bind(to: self.rx.isSelelect)
            .disposed(by: disposeBag)
    }

    func setLayout() {

        self.snp.makeConstraints {
//            $0.height.equalTo(24)
            $0.width.equalTo(97)
        }

        addSubview(frontView)

        frontView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        frontView.snp.contentHuggingHorizontalPriority = 749.0

        addSubview(countImageView)

        countImageView.snp.makeConstraints {
            $0.leading.equalTo(frontView.snp.trailing)
            $0.centerY.equalTo(frontView)
            $0.width.height.equalTo(24)
        }

        countImageView.snp.contentHuggingHorizontalPriority = 750.0

        addSubview(statusLabel)

        statusLabel.snp.makeConstraints {
            $0.leading.equalTo(countImageView.snp.trailing)
            $0.centerY.equalTo(frontView)
        }

        statusLabel.snp.contentHuggingHorizontalPriority = 750.0

        addSubview(upDownButton)

        upDownButton.snp.makeConstraints {
            $0.leading.equalTo(statusLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(frontView)
            $0.trailing.equalToSuperview().inset(2)
        }

        addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(frontView.snp.bottom)
            $0.height.equalTo(0)
            $0.leading.bottom.trailing.equalToSuperview()
        }

        tableView.snp.contentHuggingVerticalPriority = 749.0
    }
}

extension HomeDropDownView: UITableViewDelegate {

}

extension HomeDropDownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let parts = project?.parts else {
            return 0
        }

        return parts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension Reactive where Base: HomeDropDownView {
    var isSelelect: Binder<Bool> {

        return Binder(base) { base, bool in
            if bool == true {
                base.setSelect()
            } else {
                base.setNoneSelect()
            }
        }

    }
}
