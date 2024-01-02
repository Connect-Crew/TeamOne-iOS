//
//  BaseDropBox.swift
//  DSKit
//
//  Created by 강현준 on 12/5/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import Core
import SnapKit
import Then
import RxSwift

open class BaseDropBox: View {

    public var rowHeight = 40

    public var dataSource: [String] = []

    public var onSelectSubject: PublishSubject<(String, Int)>? = nil

    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 0
        }

    public init() {
        super.init(frame: .zero)

        initSetting()
    }

    open func initSetting() {
        addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.backgroundColor = .white
        self.setRound(radius: 8)
        self.setBaseShadow(radius: 8)
    }
    
    public func openDropBox(dataSource: [String], onSelectSubject: PublishSubject<(String, Int)>) {
        self.dataSource = dataSource
        self.onSelectSubject = onSelectSubject

        stackView.removeArrangeSubViewAll()
        inputData()

    }

    open func closeDropBox() {
        self.dataSource = []
        self.stackView.removeArrangeSubViewAll()
    }

    func inputData() {

        for idx in 0..<dataSource.count {
            let title = dataSource[idx]

            let button = UIButton().then {
                $0.contentHorizontalAlignment = .leading
                $0.setButton(text: title, typo: .button2, color: .teamOne.grayscaleSeven)
                $0.tag = idx
                $0.contentEdgeInsets = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10)
            }

            self.stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(onClickButton), for: .touchUpInside)
        }

        layoutIfNeeded()
    }

    @objc func onClickButton(sender: UIButton) {
        onSelectSubject?.onNext((sender.titleLabel?.text ?? "", sender.tag))
        closeDropBox()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
