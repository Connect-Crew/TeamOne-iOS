//
//  SignUpCompleteView.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import DSKit
import SnapKit
import RxCocoa
import RxSwift

final class SignUpCompleteView: UIView {
    let startButtonAction = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = UIColor.blue // 이미지가 없을 때 보일 배경 색
        
    }
    let completeLabel = UILabel().then {
        $0.setLabel(text: "회원가입 완료!", typo: .body2, color: .teamOne.grayscaleFive)
    }
    
    let titleLabel = UILabel().then {
        $0.setLabel(text: "               지금당장\n빛나는 아이디어를 함께할 \n 팀원들을 모집해보세요!", typo: .title1, color: .black)
        
    }
    
    //   let buttonColor = #colorLiteral(red: 0.9333333333, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
    
    //    let startButton = ReusableButton(buttonTitle: "시작하기",bgColor: .teamOne.mainBlue,textColor: .white,cornerRadius:10,width: 340,height:52)
    
    let startButton = UIButton().then {
        $0.setButton(text: "시작하기", typo: .button1, color: .black)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
//        startButton.rx.tap
//                    .bind(to: startButtonAction)
//                    .disposed(by: disposeBag)
//        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.layer.cornerRadius = logoImageView.bounds.width / 2
        logoImageView.image = UIImage(named: "팀 로고")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(137)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(176)
        }
        addSubview(completeLabel)
        completeLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(completeLabel.snp.bottom).offset(50)
            //  $0.leading.equalToSuperview().offset(129)
            $0.centerX.equalToSuperview()
            
        }
        titleLabel.numberOfLines = 3
        
        addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
        }
        startButton.backgroundColor = .teamOne.mainColor
    }
    
}


