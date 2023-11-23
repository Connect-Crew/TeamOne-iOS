//
//  View+EmptyImageView+Label.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

public final class View_EmptyImageView_Label: UIView {

    let imageView = UIImageView()
    let label = UILabel()

    public init(text: String, textColor: UIColor, typo: SansNeo,
                image: DSKitImage) {
        self.label.setLabel(text: text, typo: typo, color: textColor)
        self.imageView.image = .image(dsimage: image)

        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {

        self.backgroundColor = .clear

        addSubview(imageView)
        addSubview(label)

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}
