//
//  IntrinsicContentSizeCollectionView.swift
//  Core
//
//  Created by 강현준 on 1/16/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit


/// ContentSize에 따라서 UILabel처럼 intrinsicContentSize가 변경되는 UITableView
open class IntrinsicContentHeightTableView: UITableView {
    
    open override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    open override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
}
