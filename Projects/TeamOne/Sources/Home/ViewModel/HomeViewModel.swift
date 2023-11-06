//
//  HomeViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Core
import Domain

enum HomeNavigation {

}

final class HomeViewModel: ViewModel {

    // MARK: - Mocks

    let projectsMock: [SideProject] = [
        SideProject(mainImage: nil,
                    title: "강아지 의료 플랫폼 기획",
                    location: "서울",
                    isExistedperiod: true,
                    startDate: "2023.10.23",
                    endDate: "2",
                    hashTags: [HashTag(title: "진행중", backgroundColor: "pink"), HashTag(title: "IT", backgroundColor: "gray")],
                    totalTeamMember: 7,
                    currentTeamMember: 7,
                    parts: [Part(part: "개발", participants: 1)], isEmpty: false),
        SideProject(
            mainImage: nil, title: "배달비 없는 배달앱 - 함께하실분!!",
            location: "온라인",
            isExistedperiod: false,
            startDate: nil,
            endDate: nil,
            hashTags: [HashTag(title: "진행전", backgroundColor: "pink"),
                      HashTag(title: "포트폴리오", backgroundColor: "gray")],
            totalTeamMember: 5,
            currentTeamMember: 3,
            parts: [Part(part: "개발", participants: 1),
                        Part(part: "디자인", participants: 1)], isEmpty: false),
        SideProject(mainImage: nil,
                    title: "강아지 의료 플랫폼 기획",
                    location: "서울",
                    isExistedperiod: true,
                    startDate: "2023.10.23",
                    endDate: "2",
                    hashTags: [HashTag(title: "진행중", backgroundColor: "pink"), HashTag(title: "IT", backgroundColor: "gray")],
                    totalTeamMember: 7,
                    currentTeamMember: 7,
                    parts: [Part(part: "개발", participants: 1)], isEmpty: false),
        SideProject(mainImage: nil,
                    title: "강아지 의료 플랫폼 기획",
                    location: "서울",
                    isExistedperiod: true,
                    startDate: "2023.10.23",
                    endDate: "2",
                    hashTags: [HashTag(title: "진행중", backgroundColor: "pink"), HashTag(title: "IT", backgroundColor: "gray")],
                    totalTeamMember: 7,
                    currentTeamMember: 7,
                    parts: [Part(part: "개발", participants: 1)], isEmpty: false),
        SideProject(mainImage: nil,
                    title: "강아지 의료 플랫폼 기획",
                    location: "서울",
                    isExistedperiod: true,
                    startDate: "2023.10.23",
                    endDate: "2",
                    hashTags: [HashTag(title: "진행중", backgroundColor: "pink"), HashTag(title: "IT", backgroundColor: "gray")],
                    totalTeamMember: 7,
                    currentTeamMember: 7,
                    parts: [Part(part: "개발", participants: 1)], isEmpty: true)]

    struct Input {

    }

    struct Output {
        let projects: Driver<[SideProject]>
    }

    lazy var projects = BehaviorSubject<[SideProject]>(value: projectsMock)

    let navigation = PublishSubject<HomeNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        return Output(
            projects: projects.asDriver(onErrorJustReturn: [])
        )
    }
}
