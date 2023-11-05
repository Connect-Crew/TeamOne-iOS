//
//  TosView.swift
//  TeamOne
//
//  Created by 임재현 on 2023/11/01.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import DSKit
import SnapKit
import RxSwift
import RxCocoa

final class TosView: UIView {
    let disposeBag = DisposeBag()
    let title = ["서비스 이용약관","개인정보 처리방침","커뮤니티 정책","광고성 혜택 알림 수신동의 (선택)"]
    
    // let disposeBag = DisposeBag()
    let tosLabel = UILabel().then {
        $0.setLabel(text: "약관을 확인해주세요.", typo: .title1, color: .teamOne.grayscaleEight)
    }
    
    let explainLabel = UILabel().then {
        $0.setLabel(text: "팀원을 보다 안전하고 즐겁게 이용하기 위한 약관이 \n에요. 약관 동의 후 회원가입이 시작됩니다.", typo: .body3, color: .teamOne.grayscaleFive)
        
    }
    
    let nicknameLabel = UILabel().then {
        $0.setLabel(text: "닉네임", typo: .body1, color: .teamOne.grayscaleEight)
    }
    
    let allAgreeView = UIView().then {
        $0.backgroundColor = .clear
        
    }
    
    let textField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요."
        $0.borderStyle = .none
    }
    
    let allAgreeLabel = UILabel().then {
        $0.setLabel(text: "전체 동의하기", typo: .body2, color: .teamOne.grayscaleEight)
    }
    
    
    let underline = UIView().then {
        $0.backgroundColor = .gray
    }
    let checkButton = ReusableButton(buttonTitle:"",bgColor: .clear,cornerRadius: 0,width: 24,height: 24,image: UIImage(named: "check"))
    let nextButton = ReusableButton(buttonTitle: "다음",bgColor: .teamOne.mainBlue,textColor: .white,cornerRadius:10,width: 340,height:52)
    
    let loginLabel = UILabel().then {
        $0.setLabel(text: "올바른 비밀번호 입력하세요", typo: .caption2, color: .teamOne.point)
    }
    
    let checkTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    let checkButtonAction = PublishSubject<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layout()
        setupTableView()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(tosLabel)
        tosLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(119)
            $0.leading.equalToSuperview().offset(20)
        }
        addSubview(explainLabel)
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(tosLabel.snp.bottom).offset(10)
            $0.leading.equalTo(tosLabel.snp.leading)
        }
        explainLabel.numberOfLines = 2
        
        //        addSubview(nicknameLabel)
        //        nicknameLabel.snp.makeConstraints {
        //            $0.leading.equalTo(explainLabel.snp.leading)
        //            $0.top.equalTo(explainLabel.snp.bottom).offset(30)
        //        }
        //
        addSubview(allAgreeView)
        allAgreeView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(50)
            $0.leading.equalTo(explainLabel.snp.leading)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 60))
        }
        
        //
        allAgreeView.addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(24)
           // $0.centerY.equalToSuperview()
        }
        checkButton.backgroundColor = .clear
        allAgreeView.addSubview(underline)
        underline.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        //
        allAgreeView.addSubview(allAgreeLabel)
        allAgreeLabel.snp.makeConstraints {
            $0.top.equalTo(checkButton.snp.top)
            $0.leading.equalTo(checkButton.snp.trailing).offset(20)
            
        }
        //        titleLabel.numberOfLines = 3
        //
        addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            //  $0.top.equalTo(textView.snp.bottom).offset(167)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(50)
        }
        
        addSubview(checkTableView)
        checkTableView.snp.makeConstraints {
            $0.trailing.equalTo(allAgreeView.snp.trailing)
            $0.leading.equalTo(allAgreeView.snp.leading)
            $0.top.equalTo(allAgreeView.snp.bottom).offset(10)
            $0.height.equalTo(180)
            
        }
    }
    
    private func setupTableView() {
        addSubview(checkTableView)
        checkTableView.register(TosCell.self, forCellReuseIdentifier: "tosCell")
        checkTableView.dataSource = self
        checkTableView.delegate = self
        // 적절한 레이아웃 설정
//        checkTableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        checkTableView.isScrollEnabled = false
        checkTableView.separatorStyle = .none
    }
}
    
    extension TosView: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4// 예시로 5개의 셀을 표시
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tosCell", for: indexPath) as? TosCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = title[indexPath.row]
            return cell
        }
    }
    


