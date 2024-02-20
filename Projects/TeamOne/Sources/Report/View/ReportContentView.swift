//
//  ReportContentView.swift
//  TeamOne
//
//  Created by Junyoung on 2/16/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import SwiftUI
import DSKit

struct ReportContentView: View {
    
    let reportData = [
        "욕설 / 비하발언",
        "참여율 저조\n(응답률, 접속률, 투표 진행 등)",
        "프로젝트 생성, 채팅 등 도배",
        "홍보성 컨텐츠",
        "부적절한 닉네임 / 프로필 사진",
        "개인 사생활 침해",
        "19+ 음란성, 만남 유도",
        "기타"
    ]
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 20) {
                Text("님의 신고 사유를 알려주세요")
                    .font(Fonts.toFont(font: .body2))
                    .foregroundColor(Color(.teamOne.grayscaleEight))
                
                
                List {
                    ForEach(reportData, id: \.self) {
                        ReportButton(title: $0)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Color(.teamOne.bgColor))
        .cornerRadius(8)
    }
}

#Preview {
    ReportContentView()
}
