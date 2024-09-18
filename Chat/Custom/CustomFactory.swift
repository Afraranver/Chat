//
//  CustomFactory.swift
//  Chat
//
//  Created by Anver on 16/09/2024.
//

import SwiftUI
import StreamChatSwiftUI
import UIKit
import StreamChat

class CustomFactory: ViewFactory {

    @Injected(\.chatClient) public var chatClient
    
    private init() {}
    
    public static let shared = CustomFactory()
    
    func makeChannelListItem(
        channel: ChatChannel,
        channelName: String,
        avatar: UIImage,
        onlineIndicatorShown: Bool,
        disabled: Bool,
        selectedChannel: Binding<ChannelSelectionInfo?>,
        swipedChannelId: Binding<String?>,
        channelDestination: @escaping (ChannelSelectionInfo ) -> ChatChannelView<CustomFactory>,
        onItemTap: @escaping (ChatChannel) -> Void,
        trailingSwipeRightButtonTapped: @escaping (ChatChannel) -> Void,
        trailingSwipeLeftButtonTapped: @escaping (ChatChannel) -> Void,
        leadingSwipeButtonTapped: @escaping (ChatChannel) -> Void
    ) -> some View  {
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

    public func makeChannelListDividerItem() -> some View {
        Divider()
    }
    
    func navigationBarDisplayMode() -> NavigationBarItem.TitleDisplayMode {
        .automatic
    }
    
    func makeChannelHeaderViewModifier(for channel: ChatChannel) -> some ChatChannelHeaderViewModifier {
        CustomChatChannelModifier(channel: channel)
    }
    
    func makeEmptyMessagesView(for channel: ChatChannel, colors: ColorPalette) -> some View {
        EmptyMessagesView(channel: channel)
    }
    
    func makeMessageListBackground(colors: ColorPalette, isInThread: Bool) -> some View {
        let backgroundColor = ColorPaletteCustom.defaultPalette.backgroundColor
        return backgroundColor
            .ignoresSafeArea()
    }
    
    public func makeComposerInputView(
        text: Binding<String>,
        selectedRangeLocation: Binding<Int>,
        command: Binding<ComposerCommand?>,
        addedAssets: [AddedAsset],
        addedFileURLs: [URL],
        addedCustomAttachments: [CustomAttachment],
        quotedMessage: Binding<ChatMessage?>,
        maxMessageLength: Int?,
        cooldownDuration: Int,
        onCustomAttachmentTap: @escaping (CustomAttachment) -> Void,
        shouldScroll: Bool,
        removeAttachmentWithId: @escaping (String) -> Void
    ) -> some View {
        CustomComposerInputView(
            factory: CustomFactory.shared.self,
            text: text,
            selectedRangeLocation: selectedRangeLocation,
            command: command,
            addedAssets: addedAssets,
            addedFileURLs: addedFileURLs,
            addedCustomAttachments: addedCustomAttachments,
            quotedMessage: quotedMessage,
            maxMessageLength: maxMessageLength,
            cooldownDuration: cooldownDuration,
            onCustomAttachmentTap: onCustomAttachmentTap,
            removeAttachmentWithId: removeAttachmentWithId
        )
        
    }
    
    func makeComposerViewModifier() -> some ViewModifier {
        BackgroundViewModifier()
    }
    
    public func makeLeadingComposerView(
        state: Binding<PickerTypeState>,
        channelConfig: ChannelConfig?
    ) -> some View {
        AttachmentPickerTypeViewCustom(
            pickerTypeState: state,
            channelConfig: channelConfig
        )
    }
    
    public func makeTrailingComposerView(enabled: Bool, cooldownDuration: Int, onTap: @escaping () -> Void
    ) -> some View {
        TrailingComposerButtonView(enabled: enabled, onTap: onTap)
    }
    
    func makeMessageTextView(
        for message: ChatMessage,
        isFirst: Bool,
        availableWidth: CGFloat,
        scrolledId: Binding<String?>
    ) -> some View {
        CustomMessageTextView(
            message: message,
            isFirst: isFirst
        )
    }
    
    func makeMessageDateView(for message: ChatMessage) -> some View {
        EmptyView()
    }

}






