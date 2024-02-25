//
//  ReportView.swift
//  ReportFeature
//
//  Created by Junyoung on 2/25/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import SwiftUI
import ComposableArchitecture
//import DSKit

struct ReportView: View {
    let store: StoreOf<ReportReducer>
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("님의 신고 사유를 알려주세요")
//                    .font(Fonts.toFont(font: .body2))
//                    .foregroundColor(Color(.teamOne.grayscaleEight))
                
                
                List(store.reportModel) { model in
                    Text(model.title)
                        .padding(.vertical, 16)
                }
            }
        }
//        .background(Color(.teamOne.bgColor))
        .cornerRadius(8)
        
    }
}

#Preview {
    ReportView(store: Store(initialState: ReportState(), reducer: {
        ReportReducer()
    }))
}
