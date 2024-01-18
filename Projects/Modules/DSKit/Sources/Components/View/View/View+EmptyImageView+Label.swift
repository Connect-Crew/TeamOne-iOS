//
//  View+EmptyImageView+Label.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

public final class ListEmptyView: UIView {

    let imageView = UIImageView()
    
    let label = UILabel().then {
        $0.textAlignment = .center
    }
    
    lazy var contentView = UIStackView(arrangedSubviews: [
        imageView,
        label
    ]).then {
        $0.spacing = 20
        $0.axis = .vertical
        $0.alignment = .center
    }

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

        addSubview(contentView)

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(150)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
