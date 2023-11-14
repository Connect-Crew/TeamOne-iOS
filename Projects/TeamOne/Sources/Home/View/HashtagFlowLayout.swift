//
//  HashtagFlowLayout.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

class HashtagFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumInteritemSpacing = 4
        minimumLineSpacing = 4
        scrollDirection = .vertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        var leftMargin: CGFloat = 0.0
        var maxY: CGFloat = -1.0

        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 0.0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes

    }
}
