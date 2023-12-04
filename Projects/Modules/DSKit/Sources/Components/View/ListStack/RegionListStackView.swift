//
//  RegionListStackView.swift
//  DSKit
//
//  Created by 강현준 on 12/4/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import Then
import SnapKit
import RxCocoa
import RxSwift

public extension Reactive where Base: RegionListStackView {
    var regions: Binder<[String]> {
        return Binder(self.base) { view, regions in
            view.addRegions(regions)
        }
    }
}

public final class RegionListStackView: View {

    private var buttons: [UIButton] = []

    private var regions: [String] = ["서울", "경기", "인천", "강원", "부산","대구", "경주", "강릉", "울산", "경남", "경북", "광주", "대전", "충남", "충북", "전남", "전북", "제주"]

    private var horizontalCellCount: Int = 3

    public let selectLocationSubject = BehaviorSubject<String>(value: "")

    private lazy var verticalStackView = UIStackView(arrangedSubviews: [])
        .then {
            $0.axis = .vertical

            $0.setBaseShadow(radius: 8)
            $0.setRound(radius: 8)
        }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public func resetSelect() {
        selectLocationSubject.onNext("")
        buttons.forEach { $0.isSelected = false }
    }

    public func addRegions(_ regions: [String]) {
//        self.regions = regions
//        print(regions)
        layoutSubviews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutRegions()
    }

    private func layoutRegions() {
        verticalStackView.removeArrangeSubViewAll()

        var currentStackView = createHorizontalStackView()

        verticalStackView.addArrangedSubview(currentStackView)

        var currentCnt = 0

        for region in regions {
            let button = createButton(region: region)

            if currentCnt >= horizontalCellCount {
                currentStackView = createHorizontalStackView()
                verticalStackView.addArrangedSubview(currentStackView)
                currentCnt = 0
            }

            currentStackView.addArrangedSubview(button)
            currentCnt += 1
            button.addTarget(self, action: #selector(selectRegion(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
    }

    @objc func selectRegion(sender: UIButton) {
        buttons.forEach { $0.isSelected = false }
        sender.isSelected = true

        selectLocationSubject
            .onNext(sender.currentTitle ?? "")
    }

    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        return stackView
    }

    private func createButton(region: String) -> UIButton {
        return Button_IsSelected()
            .then {
                $0.noneSelectedBGColor = .white
                $0.selectedLayerColor = UIColor.clear.cgColor
                $0.noneSelectedTextColor = .teamOne.grayscaleSeven
                $0.setButton(text: region, typo: .button2, color: .black)
                $0.setRound(radius: 0)
                $0.isSelected = false
                $0.snp.remakeConstraints {
                    $0.height.equalTo(34)
                }
            }
    }
}
