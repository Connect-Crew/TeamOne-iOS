//
//  SettingMainView.swift
//  TeamOne
//
//  Created by 강현준 on 1/30/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit
import Domain

final class SettingMainView: View {
    
    enum CellInset {
        static let leading: CGFloat = 24
        static let trailing: CGFloat = 24
    }

    private let navigationView = SettingNavBar()
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    var dataSource: UITableViewDiffableDataSource<SettingSection, SettingCellType>?
    
    internal var backButtonTap: Observable<Void> {
        return navigationView.backButtonTap
    }
    
    init() {
        super.init(frame: .zero)
        
        layout()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    public func bind(output: SettingViewModel.Output) {
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        output.dataSource
            .compactMap { [weak self] dataSource in
                self?.generateSnapshot(dataSource)
            }
            .drive(onNext: { [weak self] snapshot in
                    self?.dataSource?.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
}

extension SettingMainView: UITableViewDelegate {
    
    private func configureTableView() {
        tableView.register(SettingSwitchCell.self)
        tableView.register(SettingBaseCell.self)
        tableView.backgroundColor = .teamOne.white
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        dataSource = makeDataSource()
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<SettingSection, SettingCellType> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            
            switch item  {
            case .activityNotification(let isOn):
                guard let cell = tableView.dequeueCell(SettingSwitchCell.self, for: indexPath) else {
                    return UITableViewCell()
                }
                
                cell.initSeting(with: item.title, isOn: isOn)
                
                return cell
                
            default:
                guard let cell = tableView.dequeueCell(SettingBaseCell.self, for: indexPath) else {
                    return UITableViewCell()
                }
                
                cell.initSeting(with: item.title)
                return cell
            }
        }
    }
    
        private func generateSnapshot(_ sources: [SettingDataSource]) -> NSDiffableDataSourceSnapshot<SettingSection, SettingCellType> {
            var snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingCellType>()
            
            snapshot.appendSections(SettingSection.allCases)
    
            sources.forEach { data in
                data.forEach { section, data in
                    snapshot.appendItems(data, toSection: section)
                }
            }
            return snapshot
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = SettingSection.allCases[section].title else { return nil }
        let view = SettingSectionHeader(frame: .zero)
        view.initSeting(with: title)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let lastIndex = 2
        return section == lastIndex ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let lastIndex = 2
        if section == lastIndex {
            return nil
        }
       
        let view = UIView()
        view.backgroundColor = .teamOne.grayscaleTwo
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
