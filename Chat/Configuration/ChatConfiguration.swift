//
//  ChatConfiguration.swift
//  Chat
//
//  Created by Anver on 17/09/2024.
//

import StreamChat
import UIKit
import StreamChatSwiftUI
import SwiftUI

extension ChatClient {
    static func createClient() -> ChatClient {
        var config = ChatClientConfig(apiKey: .init(apiKey))
        config.isLocalStorageEnabled = true
        return ChatClient(config: config)
    }
}

extension Appearance {
    static func defaultAppearance() -> Appearance {
        var colors = ColorPalette()
        colors.messageCurrentUserBackground = [UIColor(ColorPaletteCustom.defaultPalette.chatCurrentBgColor), UIColor(ColorPaletteCustom.defaultPalette.chatCurrentBgColor)]
        colors.messageOtherUserBackground = [UIColor(ColorPaletteCustom.defaultPalette.accentColor), UIColor(ColorPaletteCustom.defaultPalette.accentColor)]
        colors.tintColor = ColorPaletteCustom.defaultPalette.secondaryColor
        return Appearance(colors: colors)
        
    }
}

extension MessageListConfig {
    static func defaultConfig() -> MessageListConfig {
        return MessageListConfig(typingIndicatorPlacement: .bottomOverlay)
    }
}
