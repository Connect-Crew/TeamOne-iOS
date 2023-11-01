//
//  TosCell.swift
//  TeamOne
//
//  Created by 임재현 on 2023/11/01.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

class TosCell:UITableViewCell {
    
    let checkButton = UIButton().then {
        $0.setImage(UIImage(named: "check"), for: .normal)
        
    }
    
    let titleLabel = UILabel().then {
        $0.setLabel(text: "test", typo:.body3, color: .teamOne.grayscaleEight)
    }
    
    let rightButton = UIButton().then {
        $0.setImage(UIImage(named: "right"), for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier: reuseIdentifier)
        layout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().inset(40)
           // $0.centerX.equalToSuperview()
            $0.top.equalTo(5)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(8)
            $0.top.equalTo(checkButton.snp.top)
        }
        
        addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalTo(5)
            $0.trailing.equalToSuperview().inset(10)
        }
      //  checkButton.backgroundColor = .red
    }
    
}
