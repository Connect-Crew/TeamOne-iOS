//
//  PortfolioView.swift
//  TeamOne
//
//  Created by 강창혁 on 3/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import Then
import SnapKit
import RxSwift
import RxCocoa

final class PortfolioView: View {
    
    enum ImageType {
        case link
        case file
    }
    
    private let backgroundView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .teamOne.mainlightColor
    }
    
    private let fileImageView = UIImageView().then {
        $0.image = .image(dsimage: .blueChain)
    }
    
    let linkNameLabel = UILabel().then {
        $0.setLabel(text: "김구마의 포트폴리오 계획", typo: .button2, color: .mainColor)
    }
    
    let linkAdressLabel = UILabel().then {
        $0.setLabel(text: "www.naver.com", typo: .caption2, color: .teamOne.grayscaleFive)
    }
    
    let deleteButton = UIButton().then {
        $0.setImage(.image(dsimage: .delete3), for: .normal)
    }
    
    init(type: ImageType) {
        let image = type == .file ? UIImage.image(dsimage: .blueFile) : UIImage.image(dsimage: .blueChain)
        self.fileImageView.image = image
        super.init(frame: .zero)
        configureLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.layer.borderColor = UIColor.teamOne.grayscaleOne.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        backgroundView.addSubview(fileImageView)
        fileImageView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        addSubview(linkNameLabel)
        linkNameLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).inset(3.5)
            $0.leading.equalTo(backgroundView.snp.trailing).offset(8)
        }
        addSubview(linkAdressLabel)
        linkAdressLabel.snp.makeConstraints {
            $0.leading.equalTo(linkNameLabel.snp.leading)
            $0.trailing.equalTo(linkNameLabel.snp.trailing)
            $0.top.equalTo(linkNameLabel.snp.bottom).offset(2)
            
        }
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(linkNameLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(CGSize(width: 16, height: 16))
            $0.centerY.equalTo(backgroundView)
        }
    }
}
