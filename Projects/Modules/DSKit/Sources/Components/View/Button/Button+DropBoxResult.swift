//
//  Button+DropBoxResult.swift
//  DSKit
//
//  Created by 강현준 on 12/5/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import Core

open class Button_DropBoxResult: View {
    
    public var selectedBGColor: UIColor? = .teamOne.mainlightColor
    public var noneSelectedBGColor: UIColor? = .white

    public var selectedLayerColor: CGColor? = UIColor.teamOne.mainColor.cgColor
    public var noneSelectedLayerColor: CGColor? = UIColor.teamOne.grayscaleFive.cgColor

    public var selectedTextColor: UIColor? = .teamOne.mainColor
    public var noneSelectedTextColor: UIColor? = .teamOne.grayscaleFive

    public var opendLayerColor: CGColor? = UIColor.teamOne.mainColor.cgColor
    public var noneOpendLayerColor: CGColor? = UIColor.teamOne.grayscaleFive.cgColor

    public var opendImage = UIImage.image(dsimage: .up)
    public var closedImage = UIImage.image(dsimage: .down)



    // MARK: - Properties

    public let button = UIButton()
    public let imageView = UIImageView()

    public var isDropDownOpend: Bool = false {
        didSet {
            setLayoutIsOpend()
        }
    }

    public var isSelected: Bool = false {
        didSet {
            setLayout()
        }
    }

    public var noneSelectedText: String = "" {
        didSet {
            setLayout()
        }
    }

    public var selectedText: String? = nil {
        didSet {
            setLayout()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initSetting()
        initLayout()
        setLayout()
    }

    public func initSetting() {

        addSubview(button)

        button.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview()
        }

        addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }

    func initLayout() {
        button.backgroundColor = .clear
        imageView.backgroundColor = .clear

        button.setFont(typo: .button2)
        button.contentHorizontalAlignment = .left

        self.setLayer(width: 1, color: .black)
        self.setRound(radius: 8)
    }

    func setLayout() {

        if isDropDownOpend {
            self.imageView.image = opendImage
            self.layer.borderColor = opendLayerColor
        } else {
            self.imageView.image = closedImage
            self.layer.borderColor = noneOpendLayerColor
        }

        if isSelected {
            self.layer.borderColor = selectedLayerColor
            self.backgroundColor = selectedBGColor
            self.button.setTitleColor(selectedTextColor, for: .normal)
            self.button.setTitle(selectedText, for: .normal)
        } else {
            self.layer.borderColor = noneSelectedLayerColor
            self.backgroundColor = noneSelectedBGColor
            self.button.setTitleColor(noneSelectedTextColor, for: .normal)
            self.button.setTitle(noneSelectedText, for: .normal)
        }
    }

    func setLayoutIsOpend() {
        if isDropDownOpend {
            self.imageView.image = opendImage
            self.layer.borderColor = opendLayerColor
        } else {
            self.imageView.image = closedImage
            self.layer.borderColor = noneOpendLayerColor
        }

        if isSelected {
            self.layer.borderColor = selectedLayerColor
            self.backgroundColor = selectedBGColor
            self.button.setTitleColor(selectedTextColor, for: .normal)
            self.button.setTitle(selectedText, for: .normal)
        } else {
            self.layer.borderColor = noneSelectedLayerColor
            self.backgroundColor = noneSelectedBGColor
            self.button.setTitleColor(noneSelectedTextColor, for: .normal)
            self.button.setTitle(noneSelectedText, for: .normal)
        }
    }

    public func reset() {
        self.isSelected = false
        self.isDropDownOpend = false
        self.selectedText = nil
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: imageView.frame.width + 10)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
