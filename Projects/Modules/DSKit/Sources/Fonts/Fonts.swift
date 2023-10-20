//
//  Fonts.swift
//  DSKitTests
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public struct Fonts {
    public static func fontInitialize() {
        guard let regularUrl = Bundle.module.url(forResource: "SpoqaHanSans-Regular", withExtension: "ttf"),
              let lightUrl = Bundle.module.url(forResource: "SpoqaHanSans-Light", withExtension: "ttf"),
              let boldUrl = Bundle.module.url(forResource: "SpoqaHanSans-Bold", withExtension: "ttf"),
              let thinUrl = Bundle.module.url(forResource: "SpoqaHanSans-Thin", withExtension: "ttf")
        else {
            print("Failed to locate font")
            return
        }

        guard let regularProvider = CGDataProvider(url: regularUrl as CFURL),
              let lightProvider = CGDataProvider(url: lightUrl as CFURL),
              let boldProvider = CGDataProvider(url: boldUrl as CFURL),
              let thinProvider = CGDataProvider(url: thinUrl as CFURL)
        else {
            print("Failed to read font")
            return
        }

        guard let regularFont = CGFont(regularProvider),
              let lightFont = CGFont(lightProvider),
              let boldFont = CGFont(boldProvider),
              let thinFont = CGFont(thinProvider)
        else {
            print("Failed to load font")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(regularFont, &error) {
            print("Failed to register font: \(error!.takeRetainedValue())")
            return
        }

        if !CTFontManagerRegisterGraphicsFont(lightFont, &error) {
            print("Failed to register font: \(error!.takeRetainedValue())")
            return
        }

        if !CTFontManagerRegisterGraphicsFont(boldFont, &error) {
            print("Failed to register font: \(error!.takeRetainedValue())")
            return
        }

        if !CTFontManagerRegisterGraphicsFont(thinFont, &error) {
            print("Failed to register font: \(error!.takeRetainedValue())")
            return
        }
    }
}
