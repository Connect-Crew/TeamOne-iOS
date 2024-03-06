//
//  ProfileEditViewController.swift
//  TeamOne
//
//  Created by 강창혁 on 2/24/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class ProfileEditViewController: ViewController {
    
    private let viewModel: ProfileEditViewModel
    
    private let mainView = ProfileEditMainView()
    
    private let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
    
    private var firstFile: (String?, Data?)? = nil
    private var secondFile: (String?, Data?)? = nil
    private var thridFile: (String?, Data?)? = nil
    private var files: [(String?, Data?)?] = []
    
    // MARK: - Initilzer
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindPortfolioSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func bind() {
        let input = ProfileEditViewModel.Input(
            tapBackButton: mainView.navBar.backButttonTap,
            tapEditCompleteButton: mainView.navBar.completeButtonTap
        )
        
        let _ = viewModel.transform(input: input)
    }
    
    private func bindPortfolioSelected() {
        mainView.portfolioSelectView.firstFileInputView.fileFetchView.addFileButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.present(this.documentPicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.secondFileInputView.fileFetchView.addFileButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.present(this.documentPicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.thirdFileInputView.fileFetchView.addFileButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.present(this.documentPicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        documentPicker.rx.didPickDocumentsAt
            .withUnretained(self)
            .bind { this, url in
                guard let selectedFileURL = url.first else { return }
                
                selectedFileURL.startAccessingSecurityScopedResource()
                let fileName = selectedFileURL.lastPathComponent.precomposedStringWithCanonicalMapping
                let fileData = try? Data(contentsOf: selectedFileURL)
                
                guard let fileDataStorage = fileData?.count else { return }
                let megaByte = Int(pow(2.0, 20.0))
                let fileMegaByteSize = fileDataStorage / megaByte
                
                // 첫번째 포트폴리오 파일이 선택되었을때
                if this.firstFile == nil {
                    this.mainView.portfolioSelectView.firstFileInputView.nameInputView.isHidden = false
                    this.mainView.portfolioSelectView.firstFileInputView.selectedFileView.isHidden = false
                    
                    this.mainView.portfolioSelectView.firstFileInputView.selectedFileView.fileNameLabel.text = fileName.description
                    this.mainView.portfolioSelectView.firstFileInputView.selectedFileView.fileStorageLabel.text = fileMegaByteSize.description + "MB"
                    this.mainView.portfolioSelectView.firstFileInputView.fileFetchView.isHidden = true
                    this.mainView.portfolioSelectView.secondFileInputView.isHidden = false
                    
                    this.files.append((fileName, fileData))
                    this.firstFile = (fileName, fileData)
                } else if this.secondFile == nil {
                    this.mainView.portfolioSelectView.secondFileInputView.nameInputView.isHidden = false
                    this.mainView.portfolioSelectView.secondFileInputView.selectedFileView.isHidden = false
                    
                    this.mainView.portfolioSelectView.secondFileInputView.selectedFileView.fileNameLabel.text = fileName.description
                    this.mainView.portfolioSelectView.secondFileInputView.selectedFileView.fileStorageLabel.text = fileMegaByteSize.description + "MB"
                    this.mainView.portfolioSelectView.secondFileInputView.fileFetchView.isHidden = true
                    this.mainView.portfolioSelectView.thirdFileInputView.isHidden = false
                    this.files.append((fileName, fileData))
                    this.secondFile = (fileName, fileData)
                } else if this.thridFile == nil {
                    this.mainView.portfolioSelectView.thirdFileInputView.nameInputView.isHidden = false
                    this.mainView.portfolioSelectView.thirdFileInputView.selectedFileView.isHidden = false
                    this.mainView.portfolioSelectView.thirdFileInputView.fileFetchView.isHidden = true
                    this.mainView.portfolioSelectView.thirdFileInputView.selectedFileView.fileNameLabel.text = fileName.description
                    this.mainView.portfolioSelectView.thirdFileInputView.selectedFileView.fileStorageLabel.text = fileMegaByteSize.description + "MB"
                    this.files.append((fileName, fileData))
                    this.thridFile = (fileName, fileData)
                }
                selectedFileURL.stopAccessingSecurityScopedResource()
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.firstFileInputView.selectedFileView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.firstFile = nil
                this.files.remove(at: 0)
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.secondFileInputView.selectedFileView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.secondFile = nil
                this.files.remove(at: 1)
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.thirdFileInputView.selectedFileView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.thridFile = nil
                this.files.remove(at: 2)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureFile(files: [(String?, Data?)?]) {
        //이 파일들을 받아서 다시 순서대로 재설정하기
        
        files.enumerated().forEach { index, data in
            guard let (fileName, fileData) = data else { return }
            if index == 1 {
                mainView.portfolioSelectView.firsfil
            } else {
                
            }
        }
    }
    
}
