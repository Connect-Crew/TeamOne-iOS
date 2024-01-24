//
//  ApplyBottomSheetMainView.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit
import DSKit
import RxSwift
import RxCocoa
import Domain

final class ApplyMainView: UIView {

    let buttonBackground = UIButton().then {
        $0.isEnabled = false
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.7)
    }

    let applyBottomSheet = ApplyBottomSheetView()
    
    var bottomSheetConstraint: Constraint?

    let writeApplicationView = WriteApplicationView()
    
    let writeContactView = WriteContactView()

    let viewResult = ApplyResultView()

    var closeSubject = PublishRelay<Void>()

    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutApplyBottomSheet()
        layoutWriteApplicationView()
        layoutContactView()
        layoutResultView()
        setButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutApplyBottomSheet() {
        self.backgroundColor = .clear
        layoutBackgroundButton()

        addSubview(applyBottomSheet)

        // applyBottomSheet를 화면 밑으로 초기 위치 설정
        applyBottomSheet.snp.makeConstraints {
             $0.leading.trailing.equalToSuperview()
             bottomSheetConstraint = $0.bottom.equalToSuperview().offset(UIScreen.main.bounds.height).constraint
         }
    }

    private func layoutWriteApplicationView() {
        addSubview(writeApplicationView)

        writeApplicationView.isHidden = true
        writeApplicationView.isUserInteractionEnabled = false

        writeApplicationView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(45)
            $0.trailing.equalToSuperview().inset(45)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func layoutContactView() {
        self.addSubview(writeContactView)
        
        writeContactView.isHidden = true
        writeContactView.isUserInteractionEnabled = false
        
        writeContactView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(45)
            $0.trailing.equalToSuperview().inset(45)
            $0.centerY.equalToSuperview()
        }
    }

    private func layoutResultView() {
        addSubview(viewResult)

        viewResult.isHidden = true
        viewResult.isUserInteractionEnabled = false

        viewResult.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(45)
            $0.trailing.equalToSuperview().inset(45)
            $0.centerY.equalToSuperview()
        }
    }

    func showWriteApplicationView(status: RecruitStatus) {
        writeApplicationView.isHidden = false
        writeApplicationView.isUserInteractionEnabled = true

        writeApplicationView.setContent(status: status)
    }
    
    func showWriteContactView() {
        writeContactView.isHidden = false
        writeContactView.isUserInteractionEnabled = true
    }
    
    func hideWirteContaceView() {
        writeContactView.isHidden = true
    }

    func hideWriteApplicationView() {
        writeApplicationView.isHidden = true
        writeApplicationView.isUserInteractionEnabled = false
    }

    func showResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.viewResult.isHidden = false
            self?.viewResult.isUserInteractionEnabled = true
        })
    }

    func setButtons() {
        applyBottomSheet.buttonClose.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.dismissBottomSheet(isEnd: true)
            })
            .disposed(by: disposeBag)

        writeApplicationView.cancleButton.rx.tap
            .map { _ in return () }
            .bind(to: closeSubject)
            .disposed(by: disposeBag)

        viewResult.okButton.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .map { _ in return () }
            .bind(to: closeSubject)
            .disposed(by: disposeBag)
        
        writeApplicationView.applyButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { this, _ in
                this.showWriteContactView()
            })
            .disposed(by: disposeBag)
    }

    func animateBottomSheet(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            // 기존 bottom 제약 조건 업데이트
            self.bottomSheetConstraint?.update(offset: 0)
            self.layoutIfNeeded()
        }, completion: { _ in 
            completion?()
        })
    }

    @objc func dismissBottomSheet(isEnd: Bool = false, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomSheetConstraint?.update(offset: UIScreen.main.bounds.height)
            self.layoutIfNeeded()
        }, completion: { _ in
            if isEnd {
                self.closeSubject.accept(())
            }

            completion?()
        })
    }

    func layoutBackgroundButton() {
        addSubview(buttonBackground)

        buttonBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
