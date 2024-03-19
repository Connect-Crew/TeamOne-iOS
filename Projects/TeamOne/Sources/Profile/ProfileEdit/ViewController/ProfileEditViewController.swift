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
        
        //MARK: - 파일 가져오기 버튼 탭 했을때
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
        
        //MARK: - 삭제버튼 눌렀을 경우
        
        mainView.portfolioSelectView.firstFileInputView.selectedFileView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.firstFile = nil
                this.files.remove(at: 0)
                this.mainView.portfolioSelectView.firstFilePortfolioCompleteView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.secondFileInputView.selectedFileView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.secondFile = nil
                if this.files.count == 1 {
                    this.files.remove(at: 0)
                } else {
                    this.files.remove(at: 1)
                }
                
                this.mainView.portfolioSelectView.secondFilePortfolioCompleteView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.thirdFileInputView.selectedFileView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.thridFile = nil
                if this.files.count == 1 {
                    this.files.remove(at: 0)
                } else if this.files.count == 2 {
                    this.files.remove(at: 1)
                } else {
                    this.files.remove(at: 2)
                }
                this.mainView.portfolioSelectView.thridFilePortfolioCompleteView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.firstFilePortfolioCompleteView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.firstFile = nil
                this.mainView.portfolioSelectView.firstFilePortfolioCompleteView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.secondFilePortfolioCompleteView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.secondFile = nil
                if this.files.count == 1 {
                    this.files.remove(at: 0)
                } else {
                    this.files.remove(at: 1)
                }
                this.mainView.portfolioSelectView.secondFilePortfolioCompleteView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        mainView.portfolioSelectView.thridFilePortfolioCompleteView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.thridFile = nil
                if this.files.count == 1 {
                    this.files.remove(at: 0)
                } else if this.files.count == 2 {
                    this.files.remove(at: 1)
                } else {
                    this.files.remove(at: 2)
                }
                this.mainView.portfolioSelectView.thridFilePortfolioCompleteView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        //MARK: - 각 파일의 이름 입력이 끝난 경우 -> 파일 등록 완료
        
        mainView.portfolioSelectView.firstFileInputView.nameInputView.nameTextField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .bind { this, _ in
                guard this.mainView.portfolioSelectView.firstFileInputView.nameInputView.nameTextField.text != "" else {
                    this.mainView.portfolioSelectView.firstFilePortfolioCompleteView.isHidden = true
                    return
                }
                this.mainView.portfolioSelectView.firstFileInputView.isHidden = true
                this.mainView.portfolioSelectView.firstFilePortfolioCompleteView.linkNameLabel.text = this.mainView.portfolioSelectView.firstFileInputView.nameInputView.nameTextField.text
                this.mainView.portfolioSelectView.firstFilePortfolioCompleteView.linkAdressLabel.text = this.mainView.portfolioSelectView.firstFileInputView.selectedFileView.fileNameLabel.text
                this.mainView.portfolioSelectView.firstFilePortfolioCompleteView.isHidden = false
            }
            .disposed(by: disposeBag)
        
        
        
        mainView.portfolioSelectView.secondFileInputView.nameInputView.nameTextField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .bind { this, _ in
                guard this.mainView.portfolioSelectView.secondFileInputView.nameInputView.nameTextField.text != "" else {
                    this.mainView.portfolioSelectView.secondFilePortfolioCompleteView.isHidden = true
                    return
                }

                this.mainView.portfolioSelectView.secondFileInputView.isHidden = true
                this.mainView.portfolioSelectView.secondFilePortfolioCompleteView.linkNameLabel.text = this.mainView.portfolioSelectView.secondFileInputView.nameInputView.nameTextField.text
                this.mainView.portfolioSelectView.firstFilePortfolioCompleteView.linkAdressLabel.text = this.mainView.portfolioSelectView.secondFileInputView.selectedFileView.fileNameLabel.text
                this.mainView.portfolioSelectView.secondFilePortfolioCompleteView.isHidden = false
            }
            .disposed(by: disposeBag)
        
        
        
        mainView.portfolioSelectView.thirdFileInputView.nameInputView.nameTextField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .bind { this, _ in
                guard this.mainView.portfolioSelectView.thirdFileInputView.nameInputView.nameTextField.text != "" else {
                    this.mainView.portfolioSelectView.thridFilePortfolioCompleteView.isHidden = true
                    return
                }
                this.mainView.portfolioSelectView.thirdFileInputView.isHidden = true
                this.mainView.portfolioSelectView.thridFilePortfolioCompleteView.linkNameLabel.text = this.mainView.portfolioSelectView.thirdFileInputView.nameInputView.nameTextField.text
                this.mainView.portfolioSelectView.firstFilePortfolioCompleteView.linkAdressLabel.text = this.mainView.portfolioSelectView.thirdFileInputView.selectedFileView.fileNameLabel.text
                this.mainView.portfolioSelectView.thridFilePortfolioCompleteView.isHidden = false
            }
            .disposed(by: disposeBag)
    }
}
