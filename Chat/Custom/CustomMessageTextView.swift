//
//  CustomMessageTextView.swift
//  Chat
//
//  Created by Anver on 18/09/2024.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct CustomMessageTextView: View {
    @Injected(\.fonts) var fonts
    @Environment(\.colors) private var colors

    var message: ChatMessage
    var isFirst: Bool

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .font(.custom("FiraMono-Medium", size: 14))
                    .padding(.bottom, 2)
                    .foregroundColor(colors.primaryColor)
            }
            .padding()
            .padding(.bottom, 10)
            .frame(minWidth: 70)
            .messageBubble(for: message, isFirst: isFirst)
            
            Text(formatDate(message.createdAt))
                .font(.custom("FiraMono-Regular", size: 12))
                .foregroundColor(colors.secondaryColor)
                .padding([.bottom, .trailing], 8)
        }
    }
}
