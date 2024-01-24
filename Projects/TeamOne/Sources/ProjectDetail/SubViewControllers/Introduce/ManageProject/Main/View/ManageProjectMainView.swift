//
//  ManageProjectMainView.swift
//  TeamOne
//
//  Created by 강현준 on 1/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import Core
import DSKit

final class ManageProjectMainView: UIView {
    
    let buttonBackground = UIButton().then {
        $0.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.7)
    }
    
    let bottomSheet = ManageProjecBottomSheet(frame: .zero)
    
    // MARK: - Constraint
    var bottomSheetConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layoutBackgroundButton()
        layoutBottomSheet()
    }
    
    func layoutBackgroundButton() {
        addSubview(buttonBackground)
        
        buttonBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func layoutBottomSheet() {
        addSubview(bottomSheet)
        
        bottomSheet.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            bottomSheetConstraint = $0.bottom.equalToSuperview().offset(UIScreen.main.bounds.height).constraint
        }
    }
    
    func showBottomSheet(completion: (() -> Void)? = nil ) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetConstraint?.update(offset: 0)
            self.layoutIfNeeded()
        }, completion: { _ in 
            completion?()
        })
    }
    
    func dismissBottomSheet(completion: @escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetConstraint?.update(offset: UIScreen.main.bounds.height)
            self.layoutIfNeeded()
        }, completion: {
            completion($0)
        })
    }
}
