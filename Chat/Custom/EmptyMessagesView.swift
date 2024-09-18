//
//  EmptyMessagesView.swift
//  Chat
//
//  Created by Anver on 18/09/2024.
//

import SwiftUI
import StreamChatSwiftUI
import StreamChat

struct EmptyMessagesView: View {
    let channel: ChatChannel

    var body: some View {
        let chattingPartnerName = channel.lastActiveMembers
            .first { $0.id != channel.createdBy?.id }?.name ?? "Unknown User"
        
        return Text("This is the beginning of your conversation with \(chattingPartnerName).")
            .padding()
            .font(.custom("FiraMono-Bold", size: 16))
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(ColorPaletteCustom.defaultPalette.secondaryColor, lineWidth: 2)
            )
            .foregroundColor(ColorPaletteCustom.defaultPalette.textColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
}

struct BackgroundViewModifier: ViewModifier {
    let colors = ColorPaletteCustom.defaultPalette

    public func body(content: Content) -> some View {
        content
            .background(ColorPaletteCustom.defaultPalette.backgroundColor)
    }
}
