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
import DSKit

struct ReportView: View {
    let store: StoreOf<ReportReducer>
    @State private var inputText: String = ""
    @Binding var userName: String
    
    var body: some View {
        ZStack {
            VStack {
                Text("\(userName)님의 신고 사유를 알려주세요")
                    .padding(.bottom, 20)
                    .foregroundColor(Color(uiColor: UIColor.grayscaleEight))
                
                ForEach(store.reportModel) { model in
                    Button(action: {
                        store.send(.reportButtonTapped(model.type))
                    }, label: {
                        HStack {
                            Image(uiImage: model.isSelected == true
                                  ? UIImage.image(dsimage: .checkBoxCheckedBlue)!
                                  : UIImage.image(dsimage: .CheckBoxNotChecked)!
                            )
                            
                            Text(model.title)
                                .foregroundColor(
                                    model.isSelected == true
                                    ? Color(uiColor: UIColor.mainColor)
                                    : Color(uiColor: UIColor.grayscaleSeven)
                                )
                                .padding(.horizontal, 10)
                                .padding(.vertical, 12)
                            
                            if model.type == .other {
                                VStack() {
                                    TextField("", text: $inputText)
                                        .padding(.leading, 10)
                                        .overlay(
                                            Rectangle()
                                                .frame(height: 1),
                                            alignment: .bottom
                                        )
                                        .foregroundColor(
                                            model.isSelected == true
                                            ? Color(uiColor: UIColor.mainColor)
                                            : Color(uiColor: UIColor.grayscaleSeven)
                                        )
                                }
                            }
                            Spacer()
                        }
                    })
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                }
                
                HStack(spacing: 0) {
                    Button(action: {
                        
                    }, label: {
                        Text("취소")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                Color(uiColor: UIColor.grayscaleTwo)
                            )
                            .foregroundColor(Color(uiColor: UIColor.grayscaleSeven))
                    })
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("내보내기")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                Color(uiColor: UIColor.mainColor)
                            )
                            .foregroundColor(.white)
                    })
                    .buttonStyle(.plain)
                }
                .padding(.top, 20)
                
            }
        }
        .padding(.horizontal, 20)
        .cornerRadius(8)
    }
}

#Preview {
    ReportView(store: Store(initialState: ReportState(), reducer: {
        ReportReducer()
    }), userName: .constant("랄로"))
}
