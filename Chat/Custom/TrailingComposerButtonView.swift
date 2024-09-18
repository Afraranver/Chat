//
//  TrailingComposerButtonView.swift
//  Chat
//
//  Created by Anver on 18/09/2024.
//

import SwiftUI

struct TrailingComposerButtonView: View {
    var enabled: Bool
    var onTap: () -> Void

    @State private var rotationAngle: Double = 0

    var body: some View {
        Button(action: {
            if enabled {
                withAnimation(.easeInOut(duration: 0.5)) {
                    rotationAngle += 180
                    onTap()
                }
            }
        }) {
            Image(systemName: enabled ? "arrow.up.circle.fill" : "arrow.right.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(enabled ? ColorPaletteCustom.defaultPalette.accentColor : ColorPaletteCustom.defaultPalette.secondaryColor)
                .padding(8)
                .background(enabled ? ColorPaletteCustom.defaultPalette.primaryColor : Color.clear)
                .clipShape(Circle())
                .rotationEffect(.degrees(rotationAngle))
                .animation(.easeInOut(duration: 0.5), value: rotationAngle)
        }
        .disabled(!enabled)
    }
}

