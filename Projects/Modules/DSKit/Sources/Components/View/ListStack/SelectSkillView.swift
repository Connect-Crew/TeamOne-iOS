//
//  SelectSkillView.swift
//  DSKit
//
//  Created by 강현준 on 12/18/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift
import UIKit
import RxCocoa
import Then
import SnapKit
import Core

class SelectSkillFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumInteritemSpacing = 12
        minimumLineSpacing = 12
        scrollDirection = .vertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        var leftMargin: CGFloat = 0.0
        var maxY: CGFloat = -1.0

        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 0.0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes

    }
}


open class SelectSkillView: View {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SelectSkillFlowLayout())

    var skills: [String] = []

    public let selectedSkillSubject = PublishSubject<String>()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initSetting()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setSkills(skills: [String]) {
        self.skills = skills
        collectionView.reloadData()
    }

    func initSetting() {
        collectionView.register(SelectSkillCollectionViewCell.self, forCellWithReuseIdentifier: SelectSkillCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
    }
}

extension SelectSkillView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        skills.count

    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectSkillCollectionViewCell.identifier, for: indexPath) as? SelectSkillCollectionViewCell else { return UICollectionViewCell() }
        
        let skill = skills[indexPath.row]

        cell.initSetting(skill: skill)
        cell.layout()

        return cell
    }
    

}

extension SelectSkillView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectSkillCollectionViewCell.identifier, for: indexPath) as? SelectSkillCollectionViewCell else { return .zero }
        
        let skill = skills[indexPath.row]

        cell.initSetting(skill: skill)

        cell.titleLabel.sizeToFit()

        let cellWidth = cell.titleLabel.frame.width + 20

        return CGSize(width: cellWidth, height: 24)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = skills[indexPath.row]

        selectedSkillSubject.onNext(selected)
    }
}

final class SelectSkillCollectionViewCell: UICollectionViewCell, CellIdentifiable {

    var disposeBag: RxSwift.DisposeBag = .init()

    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setLabel(text: "", typo: .caption1, color: .teamOne.grayscaleSeven)
        $0.backgroundColor = .teamOne.grayscaleTwo
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func layout() {

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.layer.masksToBounds = true
    }

    func initSetting(skill: String) {
        self.titleLabel.text = skill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = self.frame.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
