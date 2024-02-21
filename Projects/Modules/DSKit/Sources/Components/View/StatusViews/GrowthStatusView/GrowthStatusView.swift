//
//  GrowthStatusView.swift
//  DSKit
//
//  Created by 강현준 on 2/13/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import SnapKit
import Then

private enum HoneyLevelProgressInfo: Int {
    
    case one = 1, two, three, four, five, six, seven
    
    var level: Int {
        switch self {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        }
    }
    
    var levelComment: String {
        switch self {
        case .one: return "시작이 반이라는 말이 있죠."
        case .two: return "실력이 또 한 단계 성장했어요!"
        case .three: return "영차영차~ 너무 잘 하고있어요!"
        case .four: return "꾸준히 배우고자 하는 당신, 너무 멋져요!"
        case .five: return "당신의 밝은 미래가 코앞이네요!"
        case .six: return "누구보다 경쟁력 있는 당신!"
        case .seven: return "당신의 실력은 만렙! 무엇이든 해낼거에요."
        }
    }
    
    var colorComment: String {
        switch self {
        case .one: return "물처럼 맑은색"
        case .two: return "아주 맑은색"
        case .three: return "맑은색"
        case .four: return "아주 연한 호박색"
        case .five: return "연한 호박색"
        case .six: return "호박색"
        case .seven: return "암갈색"
        }
    }
    
    var levelColor: UIColor {
        switch self {
        case .one: return .levelOneColor
        case .two: return .levelTwoColor
        case .three: return .levelThreeColor
        case .four: return .levelSixColor
        case .five: return .levelFiveColor
        case .six: return .levelSixColor
        case .seven: return .levelSevenColor
        }
    }
    
    var endExperience: Int {
        switch self {
        case .one: return 8
        case .two: return 17
        case .three: return 34
        case .four: return 50
        case .five: return 85
        case .six: return 114
        case .seven: return Int.max
        }
    }
    
    var shouldShowPointsToNextLevel: Bool {
        switch self {
        case .seven: return false
        default: return true
        }
    }
}

public final class GrowhStatusView: UIView {
    
    private let levelLabel = UILabel().then {
        $0.setLabel(text: "LV. 1", typo: .body4, color: .teamOne.grayscaleEight)
    }
    
    private let honeyImageView = ImageView_Honey()
    
    private let levelCommentLabel = UILabel().then {
        $0.setLabel(text: "코멘트 라벨 입니다.", typo: .caption1, color: .grayscaleFive)
        $0.snp.contentHuggingHorizontalPriority = 750
    }
    
    private let colorLabel = UILabel().then {
        $0.setLabel(text: "컬러 라벨", typo: .caption2, color: .grayscaleEight)
        $0.textAlignment = .right
        $0.snp.contentHuggingHorizontalPriority = 749
    }
    
    private let progressBar = HoneyProgressBar()
    
    private let titleTotalScoreLabel = UILabel().then {
        $0.setLabel(text: "누적점수", typo: .caption2, color: .grayscaleFive)
    }
    
    private let totalScorelabel = UILabel().then {
        $0.setLabel(text: "0", typo: .body4, color: .grayscaleEight)
    }
    
    private let titleRemainNextStepLabel = UILabel().then {
        $0.setLabel(text: "누적점수", typo: .caption2, color: .grayscaleFive)
        $0.textAlignment = .right
    }
    
    private let remainNextStepScoreLabel = UILabel().then {
        $0.setLabel(text: "0", typo: .body4, color: .grayscaleEight)
        $0.textAlignment = .right
    }
    
    private lazy var commentStackView = UIStackView(arrangedSubviews: [
        levelCommentLabel,
        colorLabel
    ]).then {
        $0.alignment = .center
    }
    
    private lazy var expTitleStackView = UIStackView(arrangedSubviews: [
        titleTotalScoreLabel,
        titleRemainNextStepLabel
    ]).then {
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    private lazy var expScoreStackView = UIStackView(arrangedSubviews: [
        totalScorelabel,
        remainNextStepScoreLabel
    ]).then {
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    private var level: HoneyLevelProgressInfo = .one
    private var exp: Int = 0
    
    public init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    private func layout() {
        addSubview(levelLabel)
        levelLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        addSubview(honeyImageView)
        honeyImageView.snp.makeConstraints {
            $0.leading.equalTo(levelLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(levelLabel)
        }
        
        addSubview(commentStackView)
        commentStackView.snp.makeConstraints {
            $0.top.equalTo(levelLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(progressBar)
        progressBar.snp.makeConstraints {
            $0.top.equalTo(commentStackView.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        addSubview(expTitleStackView)
        expTitleStackView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(expScoreStackView)
        expScoreStackView.snp.makeConstraints {
            $0.top.equalTo(expTitleStackView.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    public func setStatus(level: Int, exp: Int) {
        self.level = .init(rawValue: level) ?? .one
        self.exp = exp
        setContent()
    }
    
    private func setContent() {
        self.levelLabel.text = "LV. \(level.level)"
        self.levelCommentLabel.text = level.levelComment
        self.colorLabel.text = level.colorComment
        self.progressBar.ratio = CGFloat(Float(exp) / Float(level.endExperience))
        self.progressBar.updateProgressColor(color: level.levelColor)
        self.totalScorelabel.text = "\(Int(exp))"
        self.remainNextStepScoreLabel.text = "\(level.endExperience - exp)"
        self.honeyImageView.setLevel(exp: exp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
