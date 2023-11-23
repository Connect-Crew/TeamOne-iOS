//
//  ViewBGImage+Label.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit

public class ViewBGImage_Label: UIView {

    let backgroundImgae: UIImage?

    public var text: String {
        didSet {
            self.label.text = text
        }
    }

    let font: SansNeo
    let textColor: UIColor

    lazy var label = UILabel().then {
        $0.setLabel(text: text, typo: font, color: textColor)
    }

    lazy var imageView = UIImageView().then {
        $0.image = backgroundImgae
    }

    public init(bgImage: DSKitImage,
                text: String,
                font: SansNeo,
                textColor: UIColor) {
        self.backgroundImgae = .image(dsimage: bgImage)
        self.text = text
        self.font = font
        self.textColor = textColor

        super.init(frame: .zero)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        self.addSubview(imageView)
        self.addSubview(label)

        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(5)
        }

        imageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(label) // label의 상하단에 맞춥니다.
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

//    func layout() {
//        self.addSubview(imageView)
//        self.addSubview(label)
//
//        imageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//
//        label.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview()
//            $0.leading.equalToSuperview().offset(5)
//            $0.trailing.equalToSuperview().offset(5)
//        }
//    }

}

