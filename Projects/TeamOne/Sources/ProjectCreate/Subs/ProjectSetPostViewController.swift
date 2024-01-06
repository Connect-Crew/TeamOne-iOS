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

    let viewSetPart = RecruitSetPartView()
    
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
        createFifthStackView()
    ]).then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }

    let buttonBefore = UIButton().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.setButton(text: "이전", typo: .button1, color: .teamOne.grayscaleFive)
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

    lazy var selectedImage = PublishSubject<[UIImage]>()
    lazy var deleteImage = PublishSubject<UIImage>()
    lazy var seledtedLeaderMajorJobClass = PublishSubject<(String, Int)>()
    lazy var seledtedLeaderMajorSubClass = PublishSubject<(String, Int)>()
    lazy var seledtedRecruitMajorPart = PublishSubject<(String, Int)>()
    lazy var seledtedRecruitSubClass = PublishSubject<(String, Int)>()
    
    var imagePickerController = UIImagePickerController()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setKeyboardInset()
    }

    public func bind(output: ProjectCreateMainViewModel.Output) {
        collectionViewSelectPhoto.onClickAddPhoto
            .withLatestFrom(output.selectedImage)
            .withUnretained(self)
            .subscribe(onNext: { this, selectedImage in

                ActionSheet.baseActionSheet(source: this, title: "TeamOne", content: ["갤러리", "카메라"], onSelect: { [self] select in

                    if select == "갤러리" {
                        self.presentImagePicker(
                            ImagePickerController(
                                selectedAssets: [],
                                minCount: 1,
                                maxCount: 3 - selectedImage.count,
                                type: [.image]
                            ), animated: true, select: nil, deselect: nil, cancel: nil, finish: { url in
                                let images = url.map { $0.getAssetThumbnail() }

                                this.selectedImage.onNext(images)

                        }, completion: nil)
                    } else if select == "카메라" {
                        this.imagePickerController.delegate = this
                        this.imagePickerController.sourceType = .camera
                        this.present(this.imagePickerController, animated: true)
                    }
                })
            })
            .disposed(by: disposeBag)

        output.selectedImage
            .drive(onNext: { [weak self] images in
                self?.collectionViewSelectPhoto.setImage(images: images)
            })
            .disposed(by: disposeBag)

        collectionViewSelectPhoto.onClickDeletePhoto
            .bind(to: deleteImage)
            .disposed(by: disposeBag)

        output.selectedSkill
            .drive(viewSelectedStack.rx.list)
            .disposed(by: disposeBag)

        output.projectCanCreate
            .drive(buttonCreateProject.rx.isEnabled)
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

                if major.isDropDownOpend == false {

                    this.leaderJobClassDropBox.openDropBox(
                        dataSource: KM.shared.jobMajorCategory,
                        onSelectSubject: this.seledtedLeaderMajorJobClass)

                    major.isDropDownOpend = true

                    sub.isDropDownOpend = false
                    sub.isSelected = false

                } else if major.isDropDownOpend == true {
                    this.leaderJobClassDropBox.closeDropBox()
                    major.isDropDownOpend = false
                }
            })
            .disposed(by: disposeBag)

        seledtedLeaderMajorJobClass
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                let major = this.buttonLeaderJobMajorClass
                let sub = this.buttonLeaderJobSubClass

                major.isDropDownOpend = false
                major.isSelected = true
                major.selectedText = result.0

                sub.isDropDownOpend = false
                sub.isSelected = false
                sub.selectedText = ""
                this.seledtedLeaderMajorSubClass.onNext(("초기화", 0))

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
                        onSelectSubject: this.seledtedLeaderMajorSubClass
                    )

                    sub.isDropDownOpend = true

                } else if first.isSelected == true && sub.isDropDownOpend == true {
                    this.leaderJobClassDropBox.closeDropBox()
                    sub.isDropDownOpend = false
                }
            })
            .disposed(by: disposeBag)

        seledtedLeaderMajorSubClass
            .withUnretained(self)
            .subscribe(onNext: { this, result in

                if result.0 != "초기화" {
                    let sub = this.buttonLeaderJobSubClass

                    sub.isDropDownOpend = false
                    sub.isSelected = true
                    sub.selectedText = result.0
                }

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
                        onSelectSubject: this.seledtedRecruitMajorPart)

                    major.isDropDownOpend = true

                    sub.isDropDownOpend = false
                    sub.isSelected = false

                } else if major.isDropDownOpend == true {
                    this.leaderRecuritTeamOneDropBox.closeDropBox()
                    major.isDropDownOpend = false
                }
            })
            .disposed(by: disposeBag)

        seledtedRecruitMajorPart
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
                        dataSource: KM.shared.jobSubCategory[first.selectedText ?? ""]?.filter({ category in
                            !this.viewSetPart.recruits.contains(where: { selected in
                                selected.partSub == category })} ) ?? [],
                        onSelectSubject: this.seledtedRecruitSubClass
                    )

                    sub.isDropDownOpend = true

                } else if first.isSelected == true && sub.isDropDownOpend == true {
                    this.leaderJobClassDropBox.closeDropBox()
                    sub.isDropDownOpend = false
                }
            })
            .disposed(by: disposeBag)

        seledtedRecruitSubClass
            .withUnretained(self)
            .subscribe(onNext: { this, result in

                let major = this.buttonRecuritTeamOneMajorPart
                let sub = this.buttonRecuritTeamOneSubPart

                sub.isDropDownOpend = false
                sub.isSelected = true
                sub.selectedText = result.0

                this.viewSetPart.addRecruits(major: major.selectedText ?? "", sub: result.0)
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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonStackView.frame.height, right: 0)
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

        let categoryButtonStackView = categoryButtonStackView()

        return UIStackView(arrangedSubviews: [
            labelStackView(),
            categoryButtonStackView,
            leaderRecuritTeamOneDropBox,
            viewSetPart
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.setCustomSpacing(5, after: categoryButtonStackView)
        }

        func labelStackView() -> UIStackView {
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
            .drive(onNext: { [weak self] height in

                guard let self = self else { return }

                if height == 0 {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonStackView.frame.height, right: 0)
                } else {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ProjectSetPostViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePickerController.dismiss(animated: true)
        
        // 10. 선택된 이미지(소스)가 없을수도 있으니 옵셔널 바인딩해주고, 이미지가 선택된게 없다면 오류를 발생시킵니다.
        guard let userPickedImage = info[.originalImage] as? UIImage else {
            fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
        }
        
        self.selectedImage.onNext([userPickedImage])
    }
}
