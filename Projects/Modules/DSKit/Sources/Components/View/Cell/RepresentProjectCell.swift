//
//  RepresentProjectCell.swift
//  DSKit
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import SnapKit
import RxSwift
import RxCocoa

public struct DSRepresentProject {
    public let id: Int
    public let thumbnail: String

    public init(id: Int, thumbnail: String) {
        self.id = id
        self.thumbnail = thumbnail
    }
}

public final class RepresentProjectCell: UICollectionViewCell, CellIdentifiable {
    
    private let imageViewProject = UIImageView()
    private let button = UIButton()
    
    private var project: DSRepresentProject?
    
    public let representImageViewTap = PublishRelay<DSRepresentProject>()
    
    public var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        bind()
    }
    
    public func setProject(project: DSRepresentProject) {
        self.project = project
        
        self.imageViewProject.setTeamOneImage(path: project.thumbnail)
    }
    
    private func bind() {
        button.rx.tap
            .withUnretained(self)
            .map { this, _ in
                this.project
            }
            .compactMap { $0 }
            .bind(to: representImageViewTap)
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        layoutImageView()
        layoutButton()
        layoutContentView()
        
        imageViewProject.image = .image(dsimage: .defaultIntroduceImage)
        imageViewProject.contentMode = .scaleAspectFill
        imageViewProject.clipsToBounds = true
    }
    
    private func layoutImageView() {
        contentView.addSubview(imageViewProject)
        
        imageViewProject.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutButton() {
        contentView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutContentView() {
        contentView.setRound(radius: 4)
        contentView.clipsToBounds = true
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        imageViewProject.image = nil
        self.disposeBag = DisposeBag()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
