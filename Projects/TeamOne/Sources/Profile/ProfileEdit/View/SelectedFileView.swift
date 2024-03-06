//
//  SelectedFileView.swift
//  TeamOne
//
//  Created by 강창혁 on 3/3/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SelectedFileView: View {
    
    let fileNameLabel = UILabel().then {
        $0.setLabel(text: "식물 키우기 다이어리", typo: .button2, color: .black)
    }
    
    let fileStorageLabel = UILabel().then {
        $0.setLabel(text: "17.8M", typo: .caption2, color: .teamOne.grayscaleSeven)
    }
    
    let deleteButton = UIButton().then {
        $0.setButton(image: .delete3)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configueLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configueLayout() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.teamOne.grayscaleFive.cgColor
        
        addSubview(fileNameLabel)
        fileNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        addSubview(fileStorageLabel)
        fileStorageLabel.snp.makeConstraints {
            $0.top.equalTo(fileNameLabel.snp.bottom)
            $0.leading.equalTo(fileNameLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 16, height: 16))
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

