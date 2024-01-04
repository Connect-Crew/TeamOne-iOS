//
//  DropDownTableViewCell.swift
//  DSKit
//
//  Created by 강현준 on 1/3/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import Then
import SnapKit
import RxSwift
import RxCocoa

public class DropDownTableViewCell: UITableViewCell, CellIdentifiable {
    
    public var disposeBag: RxSwift.DisposeBag = .init()
    
    public let label = PaddingLabel().then {
        $0.textInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.setLabel(text: "dd", typo: .button2, color: .teamOne.point)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        contentView.addSubview(label)
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func set(menu: DropDownMenu, textAlignment: NSTextAlignment) {
        label.setLabel(
            text: menu.title,
            typo: menu.titleFont,
            color: menu.titleColor
        )
        
        label.textAlignment = textAlignment
        self.selectionStyle = .none
    }
}
