//
//  MyProjectCell.swift
//  DSKit
//
//  Created by Junyoung on 2/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit

import Core

public protocol UpdateCellDelegate: AnyObject {
    func update()
}

public class MyProjectCell: UICollectionViewCell {
    
    private enum Section {
        case main
    }
    
    typealias Item = HashTagDSModel
    
    private let thumnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.image = .image(dsimage: .logo)
    }
    
    private let projectTitleLabel = UILabel()
    
    private let locationPerioadContainerView = UIView()
    private let locationImageView = UIImageView().then {
        $0.image = .image(dsimage: .place)
    }
    private let locationPeriodLabel = UILabel()
    
    private let rightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    var collectionViewHeightConstraint: Constraint?
    
    public weak var delegate: UpdateCellDelegate?
    
    var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private var tagData = [HashTagDSModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        configureDataSource()
        
        self.layer.cornerRadius = 8
        self.setBaseShadow(radius: 8)
        
        addSubview(thumnailImageView)
        
        thumnailImageView.snp.makeConstraints { make in
            make.width.height.equalTo(71)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
        }
        
        addSubview(projectTitleLabel)
        projectTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(thumnailImageView.snp.right).offset(8)
            make.top.right.equalToSuperview().inset(12)
        }
        
        addSubview(locationPerioadContainerView)
        locationPerioadContainerView.addSubview(locationImageView)
        locationPerioadContainerView.addSubview(locationPeriodLabel)
        
        locationImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.bottom.equalToSuperview().inset(4)
            make.left.equalToSuperview()
        }
        
        locationPeriodLabel.snp.makeConstraints { make in
            make.left.equalTo(locationImageView.snp.right)
            make.top.bottom.equalToSuperview().inset(4)
            make.right.equalToSuperview()
        }
        
        locationPerioadContainerView.snp.makeConstraints { make in
            make.left.equalTo(thumnailImageView.snp.right).offset(8)
            make.top.equalTo(projectTitleLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(12)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(thumnailImageView.snp.right).offset(8)
            make.top.equalTo(locationPerioadContainerView.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
//            self.collectionViewHeightConstraint = make.height.equalTo(200).constraint
            make.height.equalTo(200)
        }
    }
    
    public func bind(_ model: MyProjectsDSModel) {
        
        thumnailImageView.setTeamOneImage(path: model.thumbnail)
        
        projectTitleLabel.setLabel(text: model.title, typo: .body4, color: .teamOne.grayscaleEight)
        locationPeriodLabel.setLabel(
            text: "\(model.online ? "온라인" : model.region) | \(model.createdAt.toRelativeDateString())",
            typo: .caption2,
            color: .teamOne.grayscaleSeven)
        
        var hashTagData = [HashTagDSModel]()
        
        hashTagData.append(HashTagDSModel(
            title: model.state,
            tagColor: model.state.contains("진행") ? .pink : .black
        ))
        
        hashTagData.append(HashTagDSModel(
            title: model.careerMin,
            tagColor: .pink
        ))
        
        model.category.forEach { title in
            hashTagData.append(HashTagDSModel(
                title: title,
                tagColor: .gray
            ))
        }
        
        hashTagData.append(HashTagDSModel(
            title: model.goal,
            tagColor: .gray
        ))
        
        tagData = hashTagData
        self.applySnapshot()
    }
    
}

extension MyProjectCell {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50),
                                                  heightDimension: .estimated(17))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(17))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(4)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = 4
            
            return section
        }
        
        return layout
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(tagData, toSection: .main)
        
        self.dataSource.apply(snapshot) {
            self.collectionView.performBatchUpdates(nil) { [weak self] _ in
                self?.updateCollectionViewHeight()
            }
        }
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<HashTagCell, HashTagDSModel> { cell, indexPath, itemIdentifier in
            
            cell.initSetting(tag: self.tagData[indexPath.item])
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView
        ) { (collectionView, indexPath, identifier) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
    }
    func createCell(for item: Item, indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagCell.defaultReuseIdentifier, for: indexPath) as! HashTagCell
        cell.initSetting(tag: self.tagData[indexPath.item])
        return cell
    }
    
    func updateCollectionViewHeight() {
        
        DispatchQueue.main.async {
            self.collectionView.layoutIfNeeded()
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(self.collectionView.contentSize.height)
            }
            self.delegate?.update()
        }
    }
}
