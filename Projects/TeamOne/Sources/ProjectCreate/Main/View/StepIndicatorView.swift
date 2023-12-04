//
//  StepIndicatorView.swift
//  TeamOne
//
//  Created by 강현준 on 12/1/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import Then
import DSKit

enum StepIndicatorViewStatus {
    case finish
    case current
    case none
}

final class StepIndicatorView: UIView {

    var annularLayers: [AnnularView] = []
    var lineLayers: [LineLayer] = []
    var titleLayers: [TitleLayer] = []

    lazy var contentView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 11, left: 40, bottom: 0, right: 40)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .horizontal
        $0.distribution = .equalCentering
        $0.alignment = .center
    }

    var totalStep: Int = 0 {
        didSet {
            makeTotalStep()
        }
    }

    var currentStep: Int = 0 {
        didSet {
            setCurrentStep()
        }
    }

    var titles: [String] = [] {
        didSet {
            setTitles()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    func setup() {

        self.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setTitles() {
        for idx in 0..<totalStep {
            let label = TitleLayer().then {
                $0.setLabel(text: titles[idx], typo: .caption2, color: .white)
                $0.state = .none
            }

            titleLayers.append(label)

            addSubview(label)

            label.snp.makeConstraints {
                $0.top.equalTo(annularLayers[idx].snp.bottom).offset(5)
                $0.centerX.equalTo(annularLayers[idx])
                $0.bottom.equalToSuperview()
            }
        }
    }

    func setCurrentStep() {
        for idx in 0..<totalStep {
            // 현재 스텝보다 앞선 스텝들을 완료 상태로 설정
            if idx < currentStep - 1 {
                annularLayers[idx].state = .finish
                lineLayers[idx].state = .done
                titleLayers[idx].state = .done
            }
            // 현재 스텝 설정
            else if idx == currentStep - 1 {
                annularLayers[idx].state = .current
                lineLayers[idx].state = .done
                titleLayers[idx].state = .done
            } else {
                annularLayers[idx].state = .none
                lineLayers[idx].state = .none
                titleLayers[idx].state = .none
            }
        }

        if currentStep == totalStep {
            lineLayers[totalStep].state = .done
        } else {
            lineLayers[totalStep].state = .none
        }
    }

    func makeTotalStep() {

        annularLayers = []
        lineLayers = []
        titleLayers = []

        self.contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for idx in 0..<totalStep {
            let line = LineLayer()
            line.state = .none
            lineLayers.append(line)

            let annular = AnnularView()
            annular.step = idx + 1
            annular.state = .none
            annularLayers.append(annular)

            contentView.addArrangedSubview(annular)

            if idx == totalStep - 1 {
                let lastLine = LineLayer()
                lastLine.state = .none
                lineLayers.append(lastLine)
            }
        }

        layoutLines()
    }

    func layoutLines() {
        for idx in 0..<lineLayers.count {

            let line = lineLayers[idx]

            self.addSubview(line)

            if idx == 0 {
                line.snp.makeConstraints {
                    $0.leading.equalToSuperview()
                    $0.trailing.equalTo(annularLayers[idx].snp.leading)
                    $0.centerY.equalTo(annularLayers[idx])
                }
            } else if idx == lineLayers.count - 1 {
                line.snp.makeConstraints {
                    $0.leading.equalTo(annularLayers[idx - 1].snp.trailing)
                    $0.trailing.equalToSuperview()
                    $0.centerY.equalTo(annularLayers[idx - 1])
                }
            } else {
                line.snp.makeConstraints {
                    $0.leading.equalTo(annularLayers[idx - 1].snp.trailing)
                    $0.trailing.equalTo(annularLayers[idx].snp.leading)
                    $0.centerY.equalTo(annularLayers[idx])
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
