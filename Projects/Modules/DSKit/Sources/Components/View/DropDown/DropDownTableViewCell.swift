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
    
    public let label = UILabel().then {
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
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
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
