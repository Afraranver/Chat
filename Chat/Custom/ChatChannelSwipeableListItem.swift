//
//  ChatChannelSwipeableListItem.swift
//  Chat
//
//  Created by Anver on 18/09/2024.
//

import Foundation
import UIKit
import SwiftUI
import StreamChatSwiftUI
import StreamChat


func makeChannelListItem(
    channel: ChatChannel,
    channelName: String,
    avatar: UIImage,
    onlineIndicatorShown: Bool,
    disabled: Bool,
    selectedChannel: Binding<ChannelSelectionInfo?>,
    swipedChannelId: Binding<String?>,
    channelDestination: @escaping (ChannelSelectionInfo) -> ChatChannelView<CustomFactory>,
    onItemTap: @escaping (ChatChannel) -> Void,
    trailingSwipeRightButtonTapped: @escaping (ChatChannel) -> Void,
    trailingSwipeLeftButtonTapped: @escaping (ChatChannel) -> Void,
    leadingSwipeButtonTapped: @escaping (ChatChannel) -> Void
) -> some View {
    CustomSwipeableChannelListItem(
        channel: channel,
        channelName: channelName,
        avatar: avatar,
        onlineIndicatorShown: onlineIndicatorShown,
        disabled: disabled,
        selectedChannel: selectedChannel,
        channelDestination: channelDestination,
        onItemTap: onItemTap,
        swipedChannelId: swipedChannelId,
        trailingSwipeRightButtonTapped: trailingSwipeRightButtonTapped,
        trailingSwipeLeftButtonTapped: trailingSwipeLeftButtonTapped,
        leadingSwipeButtonTapped: leadingSwipeButtonTapped
    )
}

struct CustomSwipeableChannelListItem<ChannelDestination: View>: View {
    var channel: ChatChannel
    var channelName: String
    var avatar: UIImage
    var onlineIndicatorShown: Bool
    var disabled: Bool
    @Binding var selectedChannel: ChannelSelectionInfo?
    var channelDestination: (ChannelSelectionInfo) -> ChannelDestination
    var onItemTap: (ChatChannel) -> Void
    @Binding var swipedChannelId: String?
    var trailingSwipeRightButtonTapped: (ChatChannel) -> Void
    var trailingSwipeLeftButtonTapped: (ChatChannel) -> Void
    var leadingSwipeButtonTapped: (ChatChannel) -> Void

    var body: some View {
        let customListItem = ChatChannelNavigatableListItemCustom(
            channel: channel,
            channelName: channelName,
            avatar: avatar,
            onlineIndicatorShown: onlineIndicatorShown,
            disabled: disabled,
            selectedChannel: $selectedChannel,
            channelDestination: channelDestination,
            onItemTap: onItemTap
        )
        
        return ChatChannelSwipeableListItem(
            factory: CustomFactory.shared,
            channelListItem: customListItem,
            swipedChannelId: $swipedChannelId,
            channel: channel,
            numberOfTrailingItems: 1,
            trailingRightButtonTapped: trailingSwipeRightButtonTapped,
            trailingLeftButtonTapped: trailingSwipeLeftButtonTapped,
            leadingSwipeButtonTapped: leadingSwipeButtonTapped
        )
    }
}

public struct ChatChannelNavigatableListItemCustom<ChannelDestination: View>: View {
    private var channel: ChatChannel
    private var channelName: String
    private var avatar: UIImage
    private var disabled: Bool
    private var onlineIndicatorShown: Bool
    @Binding private var selectedChannel: ChannelSelectionInfo?
    private var channelDestination: (ChannelSelectionInfo) -> ChannelDestination
    private var onItemTap: (ChatChannel) -> Void

    public init(
        channel: ChatChannel,
        channelName: String,
        avatar: UIImage,
        onlineIndicatorShown: Bool,
        disabled: Bool = false,
        selectedChannel: Binding<ChannelSelectionInfo?>,
        channelDestination: @escaping (ChannelSelectionInfo) -> ChannelDestination,
        onItemTap: @escaping (ChatChannel) -> Void
    ) {
        self.channel = channel
        self.channelName = channelName
        self.channelDestination = channelDestination
        self.onItemTap = onItemTap
        self.avatar = avatar
        self.onlineIndicatorShown = onlineIndicatorShown
        self.disabled = disabled
        _selectedChannel = selectedChannel
    }

    public var body: some View {
        ZStack {
            ChatChannelListItemCustom(
                channel: channel,
                channelName: channelName,
                injectedChannelInfo: injectedChannelInfo,
                avatar: avatar,
                onlineIndicatorShown: onlineIndicatorShown,
                disabled: disabled,
                onItemTap: onItemTap
            )

            NavigationLink(
                tag: channel.channelSelectionInfo,
                selection: $selectedChannel
            ) {
                LazyView(channelDestination(channel.channelSelectionInfo))
            } label: {
                EmptyView()
            }
        }
    }

    private var injectedChannelInfo: InjectedChannelInfo? {
        selectedChannel?.channel.cid.rawValue == channel.cid.rawValue ? selectedChannel?.injectedChannelInfo : nil
    }
}
