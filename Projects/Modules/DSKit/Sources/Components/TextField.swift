//
//  TextField.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class TextField: UITextField {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        leftViewMode = .always
        rightViewMode = .always

        leftView = UIView(frame: .init(origin: .zero, size: .init(width: 0, height: 0)))
        rightView = UIView(frame: .init(origin: .zero, size: .init(width: 0, height: 0)))
    }

}
