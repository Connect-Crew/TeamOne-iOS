//
//  IntroduceBottomView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/28.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import SnapKit
import Then

final class IntroduceBottomView: View {
    
    let buttonLike = Button_IsLiked(count: 0, typo: .caption1, isLiked: false, likedImage: .heartsolid, unLikedImage: .heartline, likedTextColor: .teamOne.point)
    
    let buttonApply = Button_IsEnabled(
        enabledString: "지원하기",
        disabledString: "지원이 모두 마감되었습니다."
    ).then {
        $0.setRound(radius: 8)
        $0.setButton(text: "", typo: .button1, color: .black)
        $0.isEnabled = true
    }
    
    let buttonProjectManagement = UIButton()
        .then {
            $0.backgroundColor = .teamOne.mainColor
            $0.setRound(radius: 8)
            $0.setButton(text: "프로젝트 관리", typo: .button1, color: .white)
        }
    
    lazy var contentView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 11, left: 24, bottom: 11, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 10
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    func layout() {
        self.addSubview(contentView)
        contentView.addArrangedSubview(buttonLike)
        contentView.addArrangedSubview(buttonProjectManagement)
        contentView.addArrangedSubview(buttonApply)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        buttonLike.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
        
        buttonProjectManagement.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    func bind(output: ProjectDetailMainViewModel.Output) {
        output.isMyProject
            .drive(onNext: { [weak self] isMyproject in
                self?.setButton(isMyproject: isMyproject)
            })
            .disposed(by: disposeBag)
    }
    
    func setButton(isMyproject: Bool) {
        
        if isMyproject == true {
            buttonApply.isHidden = true
            buttonProjectManagement.isHidden = false
        } else {
            buttonApply.isHidden = false
            buttonProjectManagement.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
