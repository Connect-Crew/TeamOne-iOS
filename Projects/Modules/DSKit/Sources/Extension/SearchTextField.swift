//
//  SearchTextField.swift
//  DSKit
//
//  Created by Junyoung on 12/6/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class SearchTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.placeholder = "관심 글 검색"
        self.font = .setFont(font: .button2)
        self.textColor = .teamOne.grayscaleFive
        
        self.layer.borderColor = UIColor.teamOne.grayscaleFive.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 12
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = leftPadding
        self.leftViewMode = UITextField.ViewMode.always

        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width + 10, height: self.frame.height))
        
        self.rightView = rightPadding
        self.rightViewMode = UITextField.ViewMode.always
    }
}
