//
//  MemberListViewController.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import Domain

final class MemberListViewController: ViewController {
    
    private enum Section: Int {
        case member
    }
    
    private enum Item: Hashable {
        case member(ProjectMember)
    }
    
    // MARK: - Components
    
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    // MARK: - Properties
    
    private var members = [ProjectMember]()
    private var isMyProject: Bool = false
    
    let profileSelected = PublishRelay<ProjectMember>()
    let representProjectSelected = PublishRelay<RepresentProject>()
    let expleMemberSelected = PublishRelay<ProjectMember>()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Inits
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupCollectionView()
        layoutCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(output: ProjectDetailMainViewModel.Output) {
        
        output.projectMembers
            .withLatestFrom(output.isMyProject) { member, isMyproject in
                return (member, isMyproject)
            }
            .drive(onNext: { [weak self] (members, isMy) in
                guard let self = self else { return }
                self.members = members
                self.isMyProject = isMy
                applySnapshot()
            })
            .disposed(by: disposeBag)
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        let sectionItems = Section.member
        
        snapshot.appendSections([sectionItems])
        
        snapshot.appendItems(members.map {
            Item.member($0)
        }, toSection: .member)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        
        collectionView.register(
            MemberListCell.self,
            forCellWithReuseIdentifier: MemberListCell.identifier
        )
        
        collectionView.backgroundColor = .teamOne.background
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                guard let self = self else { return nil }
                
                return self.createCell(
                    item: item,
                    indexPath: indexPath,
                    collectionView: collectionView
                )
            })
        
        collectionView.delegate = self
    }
    
    private func createCell(
        item: Item,
        indexPath: IndexPath,
        collectionView: UICollectionView) -> UICollectionViewCell? {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MemberListCell.identifier,
                for: indexPath
            ) as? MemberListCell,
                  case .member(let member) = item
            else {
                return UICollectionViewCell()
            }
            
            var type = MemberListCell.MemberListCellType.member
            
            type = isMyProject ? .leader : .member
            
            cell.initSetting(type: type, member: member)
            
            cell.representProjectTap
                .bind(to: representProjectSelected)
                .disposed(by: cell.disposeBag)
            
            cell.expleMemberSelected
                .bind(to: expleMemberSelected)
                .disposed(by: cell.disposeBag)
            
            return cell
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize, subitems: [item]
            )
            
            switch sectionKind {
            case .member:
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 24, bottom: 20, trailing: 24)
                section.interGroupSpacing = 20
            }
            return section
        }
        
        return layout
    }
    
    private func layoutCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MemberListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath),
              case .member(let projectMember) = item else { return }
        profileSelected.accept(projectMember)
    }
}
