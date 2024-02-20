//
//  ReportMainView.swift
//  TeamOne
//
//  Created by Junyoung on 2/16/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import SwiftUI

import DSKit

struct ReportMainView: View {
    var body: some View {
        
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ReportContentView()
                .cornerRadius(8)
        }

    }
}

#Preview {
    ReportMainView()
}
