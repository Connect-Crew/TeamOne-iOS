//
//  ReportButton.swift
//  ReportFeature
//
//  Created by Junyoung on 2/25/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import SwiftUI
import DSKit

struct ReportButton: View {
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Image(uiImage: .image(dsimage: .CheckBoxNotChecked)!)
                .frame(width: 18, height: 18)
            
            Text(title)
                .font(Fonts.toFont(font: .button2))
                .foregroundColor(Color(.grayscaleSeven))
            
            Spacer()
        }
    }
}

#Preview {
    ReportButton(title: "Title")
}
