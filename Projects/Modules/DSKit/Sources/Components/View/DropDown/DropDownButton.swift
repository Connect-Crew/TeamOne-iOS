//
//  DropDownButton.swift
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

public struct DropDownMenu {
    let title: String
    let titleColor: UIColor
    let titleFont: SansNeo
    
    public init(title: String, titleColor: UIColor, titleFont: SansNeo) {
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
    }
}

public class DropDown: UIView {
    
    var maxShowCount: Int = 4
    
    var cellHeight: CGFloat = 35
    
    var textAlignment: NSTextAlignment = .right
    
    public var completion: ((String) -> ())?
    
    lazy var stackView: UIStackView = UIStackView(
        arrangedSubviews: [
        tableView
    ]).then {
        $0.axis = .vertical
    }
    
    public lazy var tableView = UITableView().then {
        $0.isHidden = true
        $0.register(DropDownTableViewCell.self, forCellReuseIdentifier: DropDownTableViewCell.identifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    var dataSource = [DropDownMenu]() {
        didSet {
            updateTableDataSource()
        }
    }
    
    // 테이블 뷰의 최대 높이 지정
    var tableViewHeight: Constraint?
    
    public init(
        menus: [DropDownMenu],
        maxShowCount: Int,
        cellHeight: CGFloat,
        textAlignment: NSTextAlignment = .right,
        completion: ((String) -> ())? = nil
    ) {
        self.maxShowCount = maxShowCount
        self.cellHeight = cellHeight
        self.completion = completion
        self.dataSource = menus
        self.textAlignment = textAlignment
        
        super.init(frame: .zero)
        
        setup()
        updateTableDataSource()
    }
    
    func setup() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.backgroundColor = .white
        tableView.setRound(radius: 8)
        tableView.setBaseShadow(radius: 8)
        
        tableView.snp.makeConstraints {
            tableViewHeight = $0.height.equalTo(0).constraint
        }
    }
    
    func updateTableDataSource() {
        if dataSource.count >= maxShowCount {
            tableViewHeight?.update(offset: (CGFloat(maxShowCount) * cellHeight))
        }
        
        updateDropDownWidth()
    }
    
    // DropDown의 너비를 업데이트하는 함수
    func updateDropDownWidth() {
        var maxWidth: CGFloat = 0
        
        // 각 셀에 대한 너비 계산
        for i in 0..<dataSource.count {
            
            let menu = dataSource[i]
            
            let label = UILabel().then {
                $0.setLabel(text: menu.title, typo: menu.titleFont, color: menu.titleColor)
            }
            
            label.sizeToFit()
            
            let width = label.frame.width + 20 + 20
            
            maxWidth = max(maxWidth, width)
        }

        // DropDown의 너비 업데이트
        self.snp.updateConstraints {
            $0.width.equalTo(maxWidth)
        }

        // 필요에 따라서 뷰를 업데이트하기 위해 layoutIfNeeded 호출
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DropDown: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableViewCell.identifier, for: indexPath) as? DropDownTableViewCell else {
            return UITableViewCell()
        }
        
        let menu = dataSource[indexPath.row]
        
        cell.set(menu: menu, textAlignment: textAlignment)
        
        return cell
    }
}

extension DropDown: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menu = dataSource[indexPath.row]
        
        completion?(menu.title)
        tableView.isHidden = true
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeight
    }
}
