//
//  PortfolioFileInputView.swift
//  TeamOne
//
//  Created by 강창혁 on 3/3/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class PortfolioFileInputView: View {
    
    let fileFetchView = FileFetchView()
    
    let nameInputView = PortfolioNameInputView().then {
        $0.isHidden = true
    }
    
    let selectedFileView = SelectedFileView().then {
        $0.isHidden = true
    }
    
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        bindDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        let stackView = UIStackView(arrangedSubviews: [fileFetchView, nameInputView, selectedFileView])
        stackView.axis = .vertical
        stackView.spacing = 15
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindDeleteButton() {
        selectedFileView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.fileFetchView.isHidden = false
                this.nameInputView.isHidden = true
                this.selectedFileView.isHidden = true
            }
            .disposed(by: disposeBag)
    }
}
