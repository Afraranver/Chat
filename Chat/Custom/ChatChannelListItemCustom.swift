//
//  ChatChannelListItemCustom.swift
//  Chat
//
//  Created by Anver on 18/09/2024.
//

import SwiftUI
import StreamChatSwiftUI
import StreamChat

public struct ChatChannelListItemCustom: View {

    @Injected(\.fonts) private var fonts
    @Injected(\.utils) private var utils
    @Injected(\.images) private var images
    @Injected(\.chatClient) private var chatClient
    @Environment(\.colors) private var colors

    var channel: ChatChannel
    var channelName: String
    var injectedChannelInfo: InjectedChannelInfo?
    var avatar: UIImage
    var onlineIndicatorShown: Bool
    var disabled = false
    var onItemTap: (ChatChannel) -> Void

    public init(
        channel: ChatChannel,
        channelName: String,
        injectedChannelInfo: InjectedChannelInfo? = nil,
        avatar: UIImage,
        onlineIndicatorShown: Bool,
        disabled: Bool = false,
        onItemTap: @escaping (ChatChannel) -> Void
    ) {
        self.channel = channel
        self.channelName = channelName
        self.injectedChannelInfo = injectedChannelInfo
        self.avatar = avatar
        self.onlineIndicatorShown = onlineIndicatorShown
        self.disabled = disabled
        self.onItemTap = onItemTap
    }

    public var body: some View {
        Button {
            onItemTap(channel)
        } label: {
            HStack {
                ChannelAvatarView(
                    channel: channel,
                    showOnlineIndicator: onlineIndicatorShown
                )

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        ChatTitleViewCustom(name: channelName)

                        Spacer()

                        if injectedChannelInfo == nil && channel.unreadCount != .noUnread {
                            UnreadIndicatorView(
                                unreadCount: channel.unreadCount.messages
                            )
                        }
                    }

                    HStack {
                        subtitleViewCustom

                        Spacer()

                        HStack(spacing: 4) {
                            if shouldShowReadEvents {
                                MessageReadIndicatorView(
                                    readUsers: channel.readUsers(
                                        currentUserId: chatClient.currentUserId,
                                        message: channel.latestMessages.first
                                    ),
                                    showReadCount: false
                                )
                            }
                            SubtitleTextCustom(text: injectedChannelInfo?.timestamp ?? channel.timestampText)
                                .accessibilityIdentifier("timestampView")
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .padding(.top, 16)
        }
        .foregroundColor(colors.primaryColor)
        .disabled(disabled)
        .id("\(channel.id)-base")
    
    }

    private var subtitleViewCustom: some View {
        HStack(spacing: 4) {
            if let image = image {
                Image(uiImage: image)
                    .customizable()
                    .frame(maxHeight: 12)
                    .foregroundColor(colors.accentColor)
            } else {
                if channel.shouldShowTypingIndicator {
                    TypingIndicatorView()
                }
            }
            SubtitleTextCustom(text: injectedChannelInfo?.subtitle ?? channel.subtitleText)
            Spacer()
        }
        .accessibilityIdentifier("subtitleView")
    }

    private var shouldShowReadEvents: Bool {
        if let message = channel.latestMessages.first,
           message.isSentByCurrentUser,
           !message.isDeleted {
            return channel.config.readEventsEnabled
        }

        return false
    }

    private var image: UIImage? {
        if channel.isMuted {
            return images.muted
        }
        return nil
    }
    
    public struct ChatTitleViewCustom: View {

        @Injected(\.fonts) private var fonts
        @Environment(\.colors) private var colors

        var name: String

        public init(name: String) {
            self.name = name
        }

        public var body: some View {
            HStack {
                Text(name)
                    .font(.custom("FiraMono-Bold", size: 16))
                    .foregroundColor(colors.accentColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .accessibilityIdentifier("ChatTitleView")
                Spacer()
            }
        }
    }
    
    public struct SubtitleTextCustom: View {
        @Injected(\.fonts) private var fonts
        @Environment(\.colors) private var colors

        var text: String

        public init(text: String) {
            self.text = text
        }
        
        public var body: some View {
            HStack {
                Text(text)
                    .font(.custom("FiraMono-Regular", size: 12))
                    .foregroundColor(colors.accentColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}
