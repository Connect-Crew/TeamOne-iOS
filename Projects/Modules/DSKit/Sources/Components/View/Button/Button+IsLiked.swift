//
//  Button+IsLiked.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class Button_IsLiked: UIButton {

    let likedImage: UIImage?
    let unLikedImage: UIImage?
    let likedTextColor: UIColor

    public var likedCount: Int {
        didSet {
            self.setTitle("\(likedCount)", for: .normal)
        }
    }

    public var isLiked: Bool {
        didSet {
            if isLiked {
                self.setImage(likedImage, for: .normal)
            } else {
                self.setImage(unLikedImage, for: .normal)
            }
        }
    }

    public init(count: Int, typo: SansNeo, isLiked: Bool,
                likedImage: DSKitImage, unLikedImage: DSKitImage,
                likedTextColor: UIColor
    ) {
        self.likedImage = .image(dsimage: likedImage)
        self.unLikedImage = .image(dsimage: unLikedImage)
        self.likedTextColor = likedTextColor
        self.likedCount = count
        self.isLiked = isLiked

        super.init(frame: .zero)

        self.contentHorizontalAlignment = .center
        self.titleLabel?.font = .setFont(font: typo)
        self.setTitle("\(likedCount)", for: .normal)
        self.setTitleColor(likedTextColor, for: .normal)
        self.setImage(.image(dsimage: unLikedImage), for: .normal)

        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
