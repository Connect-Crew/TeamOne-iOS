//
//  ReportState.swift
//  ReportFeature
//
//  Created by Junyoung on 2/25/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct ReportData: Identifiable {
    var id = UUID()
    
    let title: String
    var isSelected: Bool
}

enum ReportType: CaseIterable {
    case abusiveLanguage
    case lowParticipation
    case spamming
    case promotionalContent
    case inappropriateNicknameOrProfilePhoto
    case privacyInvasion
    case adultContent
    case other
    
    var title: String {
        switch self {
        case .abusiveLanguage:
            return "욕설 / 비하발언"
        case .lowParticipation:
            return "참여율 저조\n(응답률, 접속률, 투표 진행 등)"
        case .spamming:
            return "프로젝트 생성, 채팅 등 도배"
        case .promotionalContent:
            return "홍보성 컨텐츠"
        case .inappropriateNicknameOrProfilePhoto:
            return "부적절한 닉네임 / 프로필 사진"
        case .privacyInvasion:
            return "개인 사생활 침해"
        case .adultContent:
            return "19+ 음란성, 만남 유도"
        case .other:
            return "기타"
        }
    }
}

@ObservableState
struct ReportState {
    var reportModel: [ReportData] = [
        ReportData(title: "욕설 / 비하발언", isSelected: false),
        ReportData(title: "참여율 저조\n(응답률, 접속률, 투표 진행 등)", isSelected: false),
        ReportData(title: "프로젝트 생성, 채팅 등 도배", isSelected: false),
        ReportData(title: "홍보성 컨텐츠", isSelected: false),
        ReportData(title: "부적절한 닉네임 / 프로필 사진", isSelected: false),
        ReportData(title: "개인 사생활 침해", isSelected: false),
        ReportData(title: "19+ 음란성, 만남 유도", isSelected: false),
        ReportData(title: "기타", isSelected: false)
    ]
}
