//
//  MyProjectVC.swift
//  TeamOne
//
//  Created by Junyoung on 2/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import Domain
import DSKit

final class MyProjectVC: ViewController {
    
    private let viewModel: MyProjectViewModel
    
    private let mainView = MyProjectMainView()
    
    private enum Section: Int, CaseIterable {
        case progress
        case completed
        
        var toString: String {
            switch self {
            case .progress:
                return "진행중"
            case .completed:
                return "완료한 프로젝트"
            }
        }
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MyProjects>!
    private var myProjects = [MyProjects]()
    
    // MARK: - LifeCycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainView.collectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource<Section, MyProjects>(collectionView: mainView.collectionView,
                                                                       cellProvider: { [weak self] collectionView, indexPath, item in
            guard let this = self else { return UICollectionViewCell() }
            
            return this.createCell(for: item, indexPath: indexPath, collectionView: collectionView)
        })
        
        configureDataSource()

    }
    
    // MARK: - Inits
    
    init(viewModel: MyProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = MyProjectViewModel.Input(
            tapBack: mainView.backButton.rx.tap.asObservable(),
            viewWillAppear: rx.viewWillAppear.map { _ in Void() }.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.projectList
            .drive(onNext: { [weak self] list in
                guard let self else { return }
                self.myProjects = list
                self.apply()
                
            })
            .disposed(by: disposeBag)
    }
}

extension MyProjectVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select : \(myProjects)")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == ElementKind.sectionHeader else {
            return UICollectionReusableView()
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyProjectHeaderView.withReuseIdentifier, for: indexPath) as! MyProjectHeaderView
        
        if indexPath.section == 0 {
            headerView.setTitle("진행중")
        } else {
            headerView.setTitle("완료된 프로젝트")
        }
        return headerView
    }
    
    private func apply() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyProjects>()
        let sectionItems = Section.allCases
        
        snapshot.appendSections(sectionItems)
        
        sectionItems.forEach {
            switch $0 {
            case .progress:
                let progressProject = myProjects.filter { $0.state.contains("진행") }
                snapshot.appendItems(progressProject, toSection: .progress)
            case .completed:
                let completedProject = myProjects.filter { $0.state.contains("완료") }
                snapshot.appendItems(completedProject, toSection: .completed)
            }
        }
        
        self.dataSource.apply(snapshot)
    }
    
    private func configureDataSource() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<MyProjectHeaderView>(
            elementKind: ElementKind.sectionHeader
        ) { (supplementaryView, _, indexPath) in
            
            switch Section(rawValue: indexPath.section) {
            case .progress:
                supplementaryView.setTitle(Section.progress.toString)
            case .completed:
                supplementaryView.setTitle(Section.completed.toString)
            case .none:
                break
            }
        }
        
        let cellRegistration = UICollectionView.CellRegistration<MyProjectCell, MyProjects> { cell, _, itemIdentifier in
            
            cell.bind(itemIdentifier.toDS())
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MyProjects>(
            collectionView: mainView.collectionView
        ) { (collectionView, indexPath, identifier) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func createCell(for item: MyProjects, indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProjectCell.defaultReuseIdentifier, for: indexPath) as! MyProjectCell
        
        return cell
    }
}
