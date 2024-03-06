//
//  PortfolioNameInputView.swift
//  TeamOne
//
//  Created by 강창혁 on 2/25/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class PortfolioNameInputView: View {
    
    private let backgroundView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .teamOne.mainlightColor
    }
    
    private let fileImageView = UIImageView().then {
        $0.image = .image(dsimage: .blueFile)
    }
    
    let nameTextField = UITextField().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.setFont(font: .button2),
            .foregroundColor: UIColor.teamOne.grayscaleFive
        ]
        
        var attributedString = NSAttributedString(
            string: "제목 입력",
            attributes: attributes
        )
        $0.attributedPlaceholder = attributedString
        $0.font = .setFont(font: .button2)
    }
    
    private lazy var horizonalDivider = UIView().then {
        $0.setDivider(height: 1, width: self.frame.width, color: .teamOne.grayscaleTwo)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        addSubview(fileImageView)
        fileImageView.snp.makeConstraints {
            $0.centerY.centerX.equalTo(backgroundView)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.leading.equalTo(backgroundView.snp.trailing).offset(8)
            $0.centerY.equalTo(fileImageView)
            $0.trailing.equalToSuperview()
        }
        
        addSubview(horizonalDivider)
        horizonalDivider.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
