//
//  SplashView.swift
//  SplashFeature
//
//  Created by 강현준 on 2/23/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import SwiftUI
import UIKit
import DSKit

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .mainColor).ignoresSafeArea()
            
            GeometryReader { geometry in
                
                VStack {
                    
                    Spacer()
                    HStack {
                        
                        Spacer()
                        Image(uiImage: .image(dsimage: .ralo)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(
                                width: 237,
                                height: 237
                            )
                            .clipped()
                        Spacer()
                        
                    }
                    Text("TEAM no.1")
                        .font(.teamOnelargeTitle)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                
            }
        }
    }
}

#Preview {
    SplashView()
}
