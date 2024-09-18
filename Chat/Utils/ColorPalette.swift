//
//  ColorPalette.swift
//  Chat
//
//  Created by Anver on 16/09/2024.
//

import SwiftUI

struct ColorPaletteCustom {
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let accentColor: Color
    let textColor: Color
    let chatCurrentBgColor: Color
}

extension ColorPaletteCustom {
    static let defaultPalette = ColorPaletteCustom(
        primaryColor: Color("PrimaryColor"),
        secondaryColor: Color("SecondaryColor"),
        backgroundColor: Color("BackgroundColor"),
        accentColor: Color("AccentColor"),
        textColor: Color("TextHeadingColor"),
        chatCurrentBgColor: Color("ChatCurrentBgColor")
    )
}

struct ColorPaletteKey: EnvironmentKey {
    static let defaultValue: ColorPaletteCustom = .defaultPalette
}

extension EnvironmentValues {
    var colors: ColorPaletteCustom {
        get { self[ColorPaletteKey.self] }
        set { self[ColorPaletteKey.self] = newValue }
    }
}

struct ColorPaletteModifier: ViewModifier {
    let colorPalette: ColorPaletteCustom
    
    func body(content: Content) -> some View {
        content
            .environment(\.colors, colorPalette)
    }
}

extension View {
    func applyColorPalette(_ colorPalette: ColorPaletteCustom) -> some View {
        self.modifier(ColorPaletteModifier(colorPalette: colorPalette))
    }
}
