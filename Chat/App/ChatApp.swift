//
//  ChatApp.swift
//  Chat
//
//  Created by Anver on 14/09/2024.
//

import SwiftUI
import SwiftData
import StreamChat
import StreamChatSwiftUI

@main
struct ChatApp: App {
    @State private var streamChat: StreamChat?
    private let chatUserManager: ChatUserManager
    private let chatClient: ChatClient
    
    init() {
        chatClient = ChatClient.createClient()
        
        streamChat = StreamChat(
            chatClient: chatClient,
            appearance: .defaultAppearance(),
            utils: Utils(messageListConfig: .defaultConfig())
        )
        
        chatUserManager = ChatUserManager(chatClient: chatClient)
        chatUserManager.connectUser()
        
    }

    var body: some Scene {
        WindowGroup {
            CustomChannelList()
                .applyColorPalette(ColorPaletteCustom.defaultPalette)
        }
    }
}
