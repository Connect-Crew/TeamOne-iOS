//
//  ProjectSetPostViewController.swift
//  TeamOne
//
//  Created by 강현준 on 12/12/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import DSKit
import RxSwift
import RxCocoa
import Then
import Domain
import RxKeyboard

final class ProjectSetPostViewController: ViewController, UINavigationControllerDelegate {
    
    private enum Section: Int {
        case recruit
    }
    
    private enum Item: Hashable {
        case recuirt(Recruit)
    }
    
    let scrollView = BaseScrollView(frame: .zero)
    
    let labelImageUploadTitle = UILabel().then {
        $0.setLabel(text: "대표 이미지 업로드", typo: .body2, color: .teamOne.grayscaleEight)
    }
    
    let labelImageUploadContent = UILabel().then {
        $0.setLabel(text: "최대 3장까지 가능합니다.", typo: .caption2, color: .teamOne.grayscaleSeven)
    }
    
    let collectionViewSelectPhoto = PhotoSelectCollectionView(height: 60, maxCount: 3)
    
    let labelIntroduceProjectPoint = UILabel().then {
        $0.setLabel(text: "* ", typo: .body2, color: .teamOne.point)
    }
    
    let labelIntroduceProjectTitle = UILabel().then {
        $0.setLabel(text: "프로젝트 소개", typo: .body2, color: .teamOne.grayscaleEight)
    }
    
    let labelSetLeaderPartPoint = UILabel().then {
        $0.setLabel(text: "* ", typo: .body2, color: .teamOne.point)
    }
    
    let labelSetLeaderPartTitle = UILabel().then {
        $0.setLabel(text: "리더의 역할", typo: .body2, color: .teamOne.grayscaleEight)
    }
    
    let labelSetLeaderPartContent = UILabel().then {
        $0.setLabel(text: "  자신이 맡을 역할을 알려주세요.", typo: .caption2, color: .teamOne.grayscaleSeven)
    }
    
    let textViewIntroduce = TextView_PlaceHolder().then {
        $0.placeholder = "어떤 아이디어에서 시작됐는지, 어떤 프로젝트인지 등 자유롭게 알려주세요! (글자수 공백포함 1000자)"
        $0.placeholderTextColor = .teamOne.grayscaleFive
        $0.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.setFont(typo: .caption1)
        $0.setRound(radius: 8)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
        $0.maxTextCount = 999
    }
    
    let buttonLeaderJobMajorClass = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "직무 대분류 선택"
    }
    
    let buttonLeaderJobSubClass = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "직무 소분류 선택"
    }
    
    let leaderJobClassDropBox = BaseDropBox()
    
    let labelSetRecuritTeamOnePoint = UILabel().then {
        $0.setLabel(text: "* ", typo: .body2, color: .teamOne.point)
    }
    
    let labelSetRecuritTeamOneTitle = UILabel().then {
        $0.setLabel(text: "팀원 모집", typo: .body2, color: .teamOne.grayscaleEight)
    }
    
    let imageViewPartWarnning = UIImageView(image: .image(dsimage: .warinning))
    
    let labelPartWarnning = UILabel().setLabel(text: "한 팀원이 여러 직무를 맡을 수 있습니다.", typo: .caption2, color: .teamOne.point)
    
    let imageViewModifyWarnning = UIImageView(image: .image(dsimage: .warinning))
    
    let labelModifyWarnning = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabel(text: "한 번 설정한 파트 별 인원은 확정된 인원이 한 명이라도 있을 시 인원수를 그보다 줄이거나 삭제할 수 없습니다.", typo: .caption2, color: .teamOne.point)
    }
    
    let labelSetRecuritTeamOneContent = UILabel().then {
        $0.setLabel(text: "  리더 포함 최대 30인까지 모집 가능합니다.", typo: .caption2, color: .teamOne.grayscaleSeven)
    }
    
    let buttonRecuritTeamOneMajorPart = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "직무 대분류 선택"
    }
    
    let buttonRecuritTeamOneSubPart = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "직무 소분류 선택"
    }
    
    let leaderRecuritTeamOneDropBox = BaseDropBox()
    
    var tableViewRecruit: IntrinsicContentHeightTableView!
    
    let labelSetStackTitle = UILabel().then {
        $0.setLabel(text: "기술 스택", typo: .body2, color: .teamOne.grayscaleEight)
    }
    
    let textFieldSetStack = TextField(frame: .zero).then {
        $0.placeholder = "프로젝트에 사용할 기술을 선택해주세요"
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
        $0.setRound(radius: 8)
        $0.textColor = .teamOne.grayscaleSeven
        $0.leftView = UIView(frame: .init(origin: .zero, size: .init(width: 10, height: 0)))
        $0.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    let viewSelectedStack = DeletableCellListStackView()
    
    let viewSelectSkill = SelectSkillView()
    
    lazy var contentView = UIStackView(arrangedSubviews: [
        createFirstStackView(),
        createSecondStackView(),
        createThirdStackView(),
        createFourthStackView(),
        createFifthStackView(),
        UIView()
    ]).then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let buttonBefore = UIButton().then {
        $0.backgroundColor = .teamOne.white
        $0.setButton(text: "이전", typo: .button1, color: .teamOne.mainColor)
        $0.setLayer(width: 1, color: .teamOne.mainColor)
        $0.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        $0.setRound(radius: 8)
    }
    
    let buttonCreateProject = Button_IsEnabled(enabledString: "프로젝트 생성", disabledString: "프로젝트 생성").then {
        $0.setRound(radius: 8)
        $0.isEnabled = false
        $0.setFont(typo: .button1)
    }
    
    lazy var buttonStackView = UIStackView(arrangedSubviews: [
        buttonBefore,
        buttonCreateProject
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.distribution = .fillEqually
        $0.spacing = 20
        $0.backgroundColor = .white
    }
    
    lazy var selectedImage = PublishSubject<[ImageWithName]>()
    lazy var deleteImage = PublishSubject<ImageWithName>()
    lazy var addedRecruit = PublishSubject<Recruit>()
    lazy var minusRecruit = PublishSubject<Recruit>()
    lazy var plusRecruit = PublishSubject<Recruit>()
    lazy var deleteRecruit = PublishSubject<Recruit>()
    lazy var changeCommentRecruit = PublishSubject<(Recruit, String)>()
    lazy var selectedLeaderPart = PublishSubject<Parts?>()
    private lazy var selectedLeaderMajorJobClass = PublishSubject<(String, Int)>()
    private lazy var selectedLeaderMajorSubClass = PublishSubject<(String, Int)>()
    private lazy var selectedRecruitMajorPart = PublishSubject<(String, Int)>()
    private lazy var selectedRecruitSubClass = PublishSubject<(String, Int)>()
    
    var imagePickerController = UIImagePickerController()
    
    var isLayoutFirst = true
    
    // MARK: - LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupRecruitTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setKeyboardInset()
    }
    
    func setupRecruitTableView() {
        tableViewRecruit = IntrinsicContentHeightTableView()
        
        tableViewRecruit.register(RecruitSetPartCell.self, forCellReuseIdentifier: RecruitSetPartCell.identifier)
        
        tableViewRecruit.separatorStyle = .none
        
        tableViewRecruit.setLayer(width: 1, color: .teamOne.grayscaleFive)
        
        tableViewRecruit.setRound(radius: 8)
    }
    
    public func bind(output: ProjectCreateMainViewModel.Output) {
        
        output.projectCreateProps
            .asObservable()
            .map { $0.recruits }
            .bind(to: tableViewRecruit.rx.items(cellIdentifier: RecruitSetPartCell.identifier, cellType: RecruitSetPartCell.self)) { [weak self] _, recruit, cell in
                
                cell.initSetting(recruit: recruit)
                
                cell.onPlus = { recruit in
                    self?.plusRecruit.onNext(recruit)
                }
                
                cell.onMinus = { recruit in
                    self?.minusRecruit.onNext(recruit)
                }
                
                cell.onDelete = {  recruit in
                    self?.deleteRecruit.onNext(recruit)
                }
                
                cell.onChangeComment = { (recruit, comment) in
                    self?.changeCommentRecruit.onNext((recruit, comment))
                }
            }
            .disposed(by: disposeBag)
        
        collectionViewSelectPhoto.onClickAddPhoto
            .withLatestFrom(output.projectCreateProps)
            .map { $0.banner }
            .withUnretained(self)
            .subscribe(onNext: { this, selectedImage in
                
                ActionSheet.baseActionSheet(source: this, title: "TeamOne", content: ["갤러리", "카메라"], onSelect: { select in
                    
                    if select == "갤러리" {
                        this.presentImagePicker(
                            ImagePickerController(
                                selectedAssets: [],
                                minCount: 1,
                                maxCount: 3 - selectedImage.count,
                                type: [.image]
                            ), animated: true, select: nil, deselect: nil, cancel: nil, finish: { assets in
                                
                                var withName: [ImageWithName] = []
                                
                                assets.map { url -> UIImage? in
                                    return url.toUIImage()
                                }
                                    .compactMap { $0 }
                                    .forEach { image in
                                        withName.append(
                                            ImageWithName(
                                                image: image
                                            ))
                                    }
                                
                                this.selectedImage.onNext(withName)
                                
                            }, completion: nil)
                    } else if select == "카메라" {
                        this.imagePickerController.delegate = this
                        this.imagePickerController.sourceType = .camera
                        this.present(this.imagePickerController, animated: true)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        output.projectCreateProps
            .map { $0.banner }
            .drive(onNext: { [weak self] images in
                self?.collectionViewSelectPhoto.setImage(images: images.map { DSImageWithName(
                    name: $0.name,
                    Image: $0.image)}
                )
            })
            .disposed(by: disposeBag)
        
        output.projectCreateProps
            .map { $0.introducion }
            .compactMap { $0 }
            .drive(textViewIntroduce.rx.text)
            .disposed(by: disposeBag)
        
        collectionViewSelectPhoto.onClickDeletePhoto
            .map { ImageWithName(name: $0.name, image: $0.Image) }
            .bind(to: deleteImage)
            .disposed(by: disposeBag)
        
        output.projectCreateProps
            .map { $0.skills }
            .drive(viewSelectedStack.rx.list)
            .disposed(by: disposeBag)
        
        output.canCreate
            .drive(buttonCreateProject.rx.isEnabled)
            .disposed(by: disposeBag)
        
        bindModify(output: output)
    }
    
    func bindModify(output: ProjectCreateMainViewModel.Output) {
        
        output.isModify
            .withLatestFrom(output.projectCreateProps)
            .map { $0.leaderParts }
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { this, partData in
                let category = this.buttonLeaderJobMajorClass
                let part = this.buttonLeaderJobSubClass
                
                category.selectedText = partData.category
                part.selectedText = partData.part
                
                category.isSelected = true
                part.isSelected = true
            })
            .disposed(by: disposeBag)
        
        output.isModify
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.buttonCreateProject.enabledString = "수정 완료"
                this.buttonCreateProject.disabledString = "수정 완료"
            })
            .disposed(by: disposeBag)
    }
    
    public override func bind() {
        bindSetLeaderPosition()
        bindSetRecruitTeamOne()
        bindSkill()
    }
    
    func bindSetLeaderPosition() {
        
        buttonLeaderJobMajorClass.button.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { this, _ in
                
                let major = this.buttonLeaderJobMajorClass
                let sub = this.buttonLeaderJobSubClass
                
                sub.isDropDownOpend = false
                sub.isSelected = false
                
                if major.isDropDownOpend == false {
                    
                    this.leaderJobClassDropBox.openDropBox(
                        dataSource: KM.shared.jobMajorCategory,
                        onSelectSubject: this.selectedLeaderMajorJobClass)
                    
                    major.isDropDownOpend = true
                    
                } else if major.isDropDownOpend == true {
                    this.leaderJobClassDropBox.closeDropBox()
                    major.isDropDownOpend = false
                }
            })
            .disposed(by: disposeBag)
        
        selectedLeaderMajorJobClass
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                let major = this.buttonLeaderJobMajorClass
                let sub = this.buttonLeaderJobSubClass
                
                major.isDropDownOpend = false
                major.isSelected = true
                major.selectedText = result.0
                
                sub.isDropDownOpend = false
                sub.isSelected = false
                
                this.selectedLeaderPart.onNext(nil)
            })
            .disposed(by: disposeBag)
        
        buttonLeaderJobSubClass.button.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { this, _ in
                
                let first = this.buttonLeaderJobMajorClass
                let sub = this.buttonLeaderJobSubClass
                
                if first.isSelected == true && sub.isDropDownOpend == false {
                    
                    this.leaderJobClassDropBox.openDropBox(
                        dataSource: KM.shared.jobSubCategory[first.selectedText ?? ""] ?? [],
                        onSelectSubject: this.selectedLeaderMajorSubClass
                    )
                    
                    sub.isDropDownOpend = true
                    
                } else if first.isSelected == true && sub.isDropDownOpend == true {
                    this.leaderJobClassDropBox.closeDropBox()
                    sub.isDropDownOpend = false
                }
            })
            .disposed(by: disposeBag)
        
        selectedLeaderMajorSubClass
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                
                let major = this.buttonLeaderJobMajorClass
                let sub = this.buttonLeaderJobSubClass
                
                sub.isDropDownOpend = false
                sub.isSelected = true
                sub.selectedText = result.0
                
                guard let majorPart = this.buttonLeaderJobMajorClass.selectedText,
                      let subPart = this.buttonLeaderJobSubClass.selectedText else { return }
                
                let key = KM.shared.key(name: subPart)
                
                let part = Parts(key: key, part: subPart, category: majorPart)
                
                this.selectedLeaderPart.onNext(part)
            })
            .disposed(by: disposeBag)
    }
    
    func bindSetRecruitTeamOne() {
        buttonRecuritTeamOneMajorPart.button.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { this, _ in
                
                let major = this.buttonRecuritTeamOneMajorPart
                let sub = this.buttonRecuritTeamOneSubPart
                
                if major.isDropDownOpend == false {
                    
                    this.leaderRecuritTeamOneDropBox.openDropBox(
                        dataSource: KM.shared.jobMajorCategory,
                        onSelectSubject: this.selectedRecruitMajorPart)
                    
                    major.isDropDownOpend = true
                    
                    sub.isDropDownOpend = false
                    sub.isSelected = false
                    
                } else if major.isDropDownOpend == true {
                    this.leaderRecuritTeamOneDropBox.closeDropBox()
                    major.isDropDownOpend = false
                }
            })
            .disposed(by: disposeBag)
        
        selectedRecruitMajorPart
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                let major = this.buttonRecuritTeamOneMajorPart
                let sub = this.buttonRecuritTeamOneSubPart
                
                major.isDropDownOpend = false
                major.isSelected = true
                major.selectedText = result.0
                
                sub.isDropDownOpend = false
                sub.isSelected = false
                sub.selectedText = ""
            })
            .disposed(by: disposeBag)
        
        buttonRecuritTeamOneSubPart.button.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { this, _ in
                
                let first = this.buttonRecuritTeamOneMajorPart
                let sub = this.buttonRecuritTeamOneSubPart
                
                if first.isSelected == true && sub.isDropDownOpend == false {
                    
                    this.leaderRecuritTeamOneDropBox.openDropBox(
                        dataSource: KM.shared.jobSubCategory[first.selectedText ?? ""] ?? [],
                        onSelectSubject: this.selectedRecruitSubClass
                    )
                    
                    sub.isDropDownOpend = true
                    
                } else if first.isSelected == true && sub.isDropDownOpend == true {
                    this.leaderJobClassDropBox.closeDropBox()
                    sub.isDropDownOpend = false
                }
            })
            .disposed(by: disposeBag)
        
        selectedRecruitSubClass
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                
                let major = this.buttonRecuritTeamOneMajorPart
                let sub = this.buttonRecuritTeamOneSubPart
                
                sub.isDropDownOpend = false
                sub.isSelected = true
                sub.selectedText = result.0
                
                if let major = major.selectedText,
                   let sub = sub.selectedText {
                    this.addedRecruit.onNext(
                        Recruit(
                            category: major,
                            part: sub,
                            comment: "",
                            max: 1)
                    )
                }
                
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindSkill() {
        textFieldSetStack.rx.text.orEmpty
            .withUnretained(self)
            .bind(onNext: { this, text in
                if text.isEmpty {
                    this.viewSelectSkill.isHidden = true
                } else {
                    this.viewSelectSkill.isHidden = false
                }
                
                if !text.isEmpty {
                    var skills: [String] = []
                    skills.append(text)
                    
                    for skill in KM.shared.skills {
                        if skill.contains(text) {
                            skills.append(skill)
                        }
                    }
                    
                    this.viewSelectSkill.setSkills(skills: skills)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.contentView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        textViewIntroduce.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        [imageViewPartWarnning, imageViewModifyWarnning].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(16)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isLayoutFirst {
            isLayoutFirst = false
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonStackView.frame.height, right: 0)
        }
    }
    
    func createFirstStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelStackView(),
            collectionViewSelectPhoto
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        func labelStackView() -> UIStackView {
            return UIStackView(arrangedSubviews: [
                labelImageUploadTitle,
                labelImageUploadContent,
                UIView()
            ]).then {
                $0.axis = .horizontal
                $0.spacing = 8
                $0.alignment = .bottom
            }
        }
    }
    
    func createSecondStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelStackView(),
            textViewIntroduce
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        func labelStackView() -> UIStackView {
            return UIStackView(arrangedSubviews: [
                labelIntroduceProjectPoint,
                labelIntroduceProjectTitle,
                UIView()
            ]).then {
                $0.axis = .horizontal
                $0.spacing = 0
            }
        }
    }
    
    func createThirdStackView() -> UIStackView {
        
        let categoryButtonStackView = categoryButtonStackView()
        return UIStackView(arrangedSubviews: [
            labelStackView(),
            categoryButtonStackView,
            leaderJobClassDropBox
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.setCustomSpacing(5, after: categoryButtonStackView)
        }
        
        func labelStackView() -> UIStackView {
            return UIStackView(arrangedSubviews: [
                labelSetLeaderPartPoint,
                labelSetLeaderPartTitle,
                labelSetLeaderPartContent,
                UIView()
            ]).then {
                $0.axis = .horizontal
                $0.spacing = 0
                $0.alignment = .bottom
            }
        }
        
        func categoryButtonStackView() -> UIStackView {
            return UIStackView(arrangedSubviews: [
                buttonLeaderJobMajorClass,
                buttonLeaderJobSubClass
            ]).then {
                $0.axis = .horizontal
                $0.spacing = 20
                $0.distribution = .fillEqually
            }
        }
    }
    
    func createFourthStackView() -> UIStackView {
        
        let labelStackView = makeLabelStackView()
        let categoryButtonStackView = categoryButtonStackView()
        let partWarnning = makeWarnningStackView(subViews: [imageViewPartWarnning, labelPartWarnning])
        let modifyWarnning = makeWarnningStackView(subViews: [imageViewModifyWarnning, labelModifyWarnning])
        return UIStackView(arrangedSubviews: [
            labelStackView,
            partWarnning,
            modifyWarnning,
            categoryButtonStackView,
            leaderRecuritTeamOneDropBox,
            tableViewRecruit
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fill
            $0.setCustomSpacing(5, after: categoryButtonStackView)
            $0.setCustomSpacing(5, after: partWarnning)
        }
        
        func makeLabelStackView() -> UIStackView {
            return UIStackView(arrangedSubviews: [
                labelSetRecuritTeamOnePoint,
                labelSetRecuritTeamOneTitle,
                labelSetRecuritTeamOneContent,
                UIView()
            ]).then {
                $0.axis = .horizontal
                $0.spacing = 0
                $0.alignment = .bottom
            }
        }
        
        func categoryButtonStackView() -> UIStackView {
            return UIStackView(arrangedSubviews: [
                buttonRecuritTeamOneMajorPart,
                buttonRecuritTeamOneSubPart
            ]).then {
                $0.axis = .horizontal
                $0.spacing = 20
                $0.distribution = .fillEqually
            }
        }
    }
    
    func createFifthStackView() -> UIStackView {
        
        return UIStackView(arrangedSubviews: [
            labelStackView(),
            textFieldSetStack,
            viewSelectedStack,
            viewSelectSkill
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.setCustomSpacing(5, after: textFieldSetStack)
        }
        
        func labelStackView() -> UIStackView {
            return UIStackView(arrangedSubviews: [
                labelSetStackTitle
            ]).then {
                $0.axis = .horizontal
                $0.spacing = 0
            }
        }
    }
    
    func setKeyboardInset() {
        RxKeyboard.instance.visibleHeight
            .distinctUntilChanged()
            .drive(onNext: { [weak self] height in
                
                guard let self = self else { return }
                
                if height == 0 {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonStackView.frame.height, right: 0)
                } else {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                    
                    if let firstResponder = findFirstResponder(in: self.scrollView) {
                        if firstResponder == textFieldSetStack {
                            let skillViewFrame = self.scrollView.convert(viewSelectSkill.frame, from: viewSelectSkill.superview)
                            self.scrollView.scrollRectToVisible(skillViewFrame, animated: true)
                        } else {
                            let frame = self.scrollView.convert(firstResponder.frame, from: firstResponder.superview)
                            self.scrollView.scrollRectToVisible(frame, animated: true)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func findFirstResponder(in view: UIView) -> UIView? {
        for subview in view.subviews {
            if subview.isFirstResponder {
                return subview
            }
            
            if let recursiveSubview = findFirstResponder(in: subview) {
                return recursiveSubview
            }
        }
        return nil
    }
    
    func makeWarnningStackView(subViews: [UIView]) -> UIStackView {
        return UIStackView(arrangedSubviews: subViews).then {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .top
        }
    }
}

extension ProjectSetPostViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePickerController.dismiss(animated: true)
        
        // 선택된 이미지(소스)가 없을수도 있으니 옵셔널 바인딩해주고, 이미지가 선택된게 없다면 오류를 발생시킵니다.
        guard let userPickedImage = info[.originalImage] as? UIImage else {
            fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
        }
        
        let image = ImageWithName(image: userPickedImage)
        
        self.selectedImage.onNext([image])
    }
}
