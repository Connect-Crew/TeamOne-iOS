//
//  FileFetchView.swift
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

final class FileFetchView: View {
    
    private let buttonBackgroundView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .teamOne.grayscaleTwo
    }
    
    private let fileImageView = UIImageView().then {
        $0.image = .image(dsimage: .grayFile)
    }
    
    private let addFileLabel = UILabel().then {
        $0.setLabel(text: "파일 가져오기", typo: .caption2, color: .teamOne.grayscaleFive)
    }

    let addFileButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        backgroundColor = .white
        addSubview(buttonBackgroundView)
        buttonBackgroundView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(6)
        }
        buttonBackgroundView.addSubview(fileImageView)
        fileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }
        buttonBackgroundView.addSubview(addFileLabel)
        addFileLabel.snp.makeConstraints {
            $0.leading.equalTo(fileImageView.snp.trailing)
            $0.centerY.equalTo(fileImageView)
            $0.trailing.equalToSuperview().inset(8)
        }
        buttonBackgroundView.addSubview(addFileButton)
        addFileButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
