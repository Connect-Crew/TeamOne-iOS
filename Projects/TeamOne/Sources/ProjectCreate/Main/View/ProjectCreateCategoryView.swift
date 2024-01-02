//
//  ProjectCreateCategoryView.swift
//  TeamOne
//
//  Created by 강현준 on 12/8/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class ProjectCreateCategoryView: View {

    var noneSelectedBGColor: UIColor = .clear
    var selectedBGColor: UIColor = .white

    var noneSelectedLayerColor: CGColor = UIColor.teamOne.grayscaleTwo.cgColor
    var selectedLayerColor: CGColor = UIColor.black.cgColor

    var noneSelectedTitleColor: UIColor = .teamOne.grayscaleSeven
    var selectedTitleColor: UIColor = .teamOne.mainColor

        var categoryImgae: UIImage? {
            didSet {
                if categoryImgae != nil {
                    setLayout()
                }
            }
        }

        var categoryTitle: String = "" {
            didSet {
                setLayout()
            }
        }

    // MARK: - Properties

    let imageView = UIImageView()

    let titleLabel = UILabel().then {
        $0.setLabel(text: "", typo: .caption1, color: .teamOne.grayscaleSeven)
    }

    let backgroundButton = UIButton()

    lazy var contentView = UIStackView(arrangedSubviews: [
        UIView(),
        imageView,
        titleLabel,
        UIView()
    ]).then {
        $0.axis = .vertical
        $0.alignment = .center
    }

    lazy var containerView = UIStackView(arrangedSubviews: [
        contentView
    ]).then {
        $0.alignment = .center
    }

    var isSelected: Bool = false {
        didSet {
            setLayout()
        }
    }

    var tapSubject = PublishSubject<String>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        self.layer.borderWidth = 1
        self.clipsToBounds = true

        self.addSubview(containerView)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.addSubview(backgroundButton)

        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        setLayout()
    }

    func setLayout() {

        self.imageView.image = categoryImgae
        titleLabel.text = categoryTitle

        if isSelected {
            self.layer.borderColor = self.selectedLayerColor
            self.backgroundColor = self.selectedBGColor
            self.titleLabel.textColor = self.selectedTitleColor
        } else {
            self.layer.borderColor = self.noneSelectedLayerColor
            self.backgroundColor = self.noneSelectedBGColor
            self.titleLabel.textColor = self.noneSelectedTitleColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setRoundCircle()
    }
}
