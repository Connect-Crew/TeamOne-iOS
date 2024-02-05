//
//  MyProjectView.swift
//  TeamOne
//
//  Created by Junyoung on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class MyProjectView: UIView {
    
    private let headerView = UIView()
    private let headerTitle = UILabel().then {
        $0.setLabel(text: "나의 프로젝트", typo: .body4, color: .teamOne.grayscaleEight)
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private let dividerView = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleTwo)
    }
    
    private let myProjectItems = MyProjectType.allCases
    
    private let disposeBag = DisposeBag()
    
    public let myProjectType = PublishSubject<MyProjectType>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(38)
        }
        
        headerView.addSubview(headerTitle)
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
        }
        
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(10)
        }
        
        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        myProjectItems
            .forEach { type in
                let view = createView(type)
                contentStackView.addArrangedSubview(view)
            }
    }
}

extension MyProjectView {
    private func createView(_ type: MyProjectType) -> UIView {
        let view = UIView()
        
        let label = UILabel().then {
            $0.setLabel(text: type.toName, typo: .button2, color: .teamOne.grayscaleEight)
        }
        
        let button = UIButton()
        
        let imageView = UIImageView().then {
            switch type {
            case .myProject:
                $0.image = .image(dsimage: .myProject)
            case .submittedProject:
                $0.image = .image(dsimage: .submittedProject)
            case .favoriteProject:
                $0.image = .image(dsimage: .favoriteProject)
            }
        }
        
        view.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(24)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.rx.tap
            .map { type }
            .bind(to: myProjectType)
            .disposed(by: disposeBag)
        
        return view
    }
}
