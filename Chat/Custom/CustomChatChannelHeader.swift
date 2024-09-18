//
//  CustomChatChannelHeader.swift
//  Chat
//
//  Created by Anver on 18/09/2024.
//

import Foundation
import SwiftUI
import StreamChatSwiftUI
import StreamChat

public struct CustomChatChannelModifier: ChatChannelHeaderViewModifier {
    
    @State private var isActive: Bool = false
    public var channel: ChatChannel
    @Environment(\.colors) private var colors
    @ObservedObject private var channelHeaderLoader = InjectedValues[\.utils].channelHeaderLoader

    public func body(content: Content) -> some View {
        content.toolbar {
            CustomChatChannelHeader(
                channel: channel,
                headerImage: channelHeaderLoader.image(
                    for: channel
                ),
                isActive: $isActive
            )
        }
        .background(
            VStack {
                Spacer()
                Divider()
                    .background(colors.backgroundColor.opacity(0.3))
                    .frame(height: 1)
            }
        )
        .toolbarBackground(colors.backgroundColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

public struct CustomChatChannelHeader: ToolbarContent {
    @Injected(\.fonts) private var fonts
    @Injected(\.utils) private var utils
    @Environment(\.colors) private var colors
    @Injected(\.chatClient) private var chatClient
    
    public var channel: ChatChannel
    public var headerImage: UIImage
    @Binding public var isActive: Bool

    private var currentUserId: String {
        chatClient.currentUserId ?? ""
    }

    private var shouldShowTypingIndicator: Bool {
        !channel.currentlyTypingUsersFiltered(currentUserId: currentUserId).isEmpty
            && utils.messageListConfig.typingIndicatorPlacement == .navigationBar
            && channel.config.typingEventsEnabled
    }

    private var onlineIndicatorShown: Bool {
        !channel.lastActiveMembers.filter { member in
            member.id != chatClient.currentUserId && member.isOnline
        }
        .isEmpty
    }

    public init(
        channel: ChatChannel,
        headerImage: UIImage,
        isActive: Binding<Bool>
    ) {
        self.channel = channel
        self.headerImage = headerImage
        _isActive = isActive
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack {
                ChannelAvatarView(
                    avatar: headerImage,
                    showOnlineIndicator: onlineIndicatorShown,
                    size: CGSize(width: 36, height: 36)
                )
                .padding(.leading,0)
                .accessibilityIdentifier("ChannelAvatarView")

                ChannelTitleView(
                    channel: channel,
                    shouldShowTypingIndicator: shouldShowTypingIndicator
                )
                .accessibilityIdentifier("ChannelTitleView")
                .accessibilityElement(children: .contain)
                
                Spacer()
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            ZStack {
                Button(action: {
                    resignFirstResponder()
                    isActive = true
                }) {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(8)
                        .background(colors.backgroundColor)
                        .foregroundColor(colors.accentColor)
                        .clipShape(Circle())
                }
                .accessibilityLabel("More options")
                
                NavigationLink(isActive: $isActive) {
                    LazyView(ChatChannelInfoView(channel: channel, shownFromMessageList: true))
                } label: {
                    EmptyView()
                }
            }
        }
    }
}

struct ChannelTitleView: View {

    @Injected(\.fonts) private var fonts
    @Injected(\.utils) private var utils
    @Environment(\.colors) private var colors
    @Injected(\.chatClient) private var chatClient

    var channel: ChatChannel
    var shouldShowTypingIndicator: Bool

    private var currentUserId: String {
        chatClient.currentUserId ?? ""
    }

    private var channelNamer: ChatChannelNamer {
        utils.channelNamer
    }

    var body: some View {
        VStack(spacing: 2) {
            Text(channelNamer(channel, currentUserId) ?? "")
                .font(.custom("FiraMono-Bold", size: 14))
                .foregroundColor(colors.accentColor)
                .accessibilityIdentifier("chatName")

            if shouldShowTypingIndicator {
                HStack {
                    TypingIndicatorView()
                    SubtitleText(text: channel.typingIndicatorString(currentUserId: currentUserId))
                }
            }
        }
    }
}
