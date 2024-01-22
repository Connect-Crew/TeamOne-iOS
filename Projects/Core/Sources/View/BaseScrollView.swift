//
//  BaseScrollView.swift
//  Core
//
//  Created by 강현준 on 12/2/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

open class BaseScrollView: UIScrollView {

    public let contentView = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initSetting()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSetting() {

        self.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalTo(self.contentLayoutGuide)
            $0.width.equalTo(self.frameLayoutGuide)
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
