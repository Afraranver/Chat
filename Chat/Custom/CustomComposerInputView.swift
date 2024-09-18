//
//  CustomComposerInputView.swift
//  Chat
//
//  Created by Anver on 18/09/2024.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

public struct CustomComposerInputView<Factory: ViewFactory>: View, KeyboardReadable {

    @EnvironmentObject var viewModel: MessageComposerViewModel
    @Environment(\.colors) private var colorsCus
    @Injected(\.colors) private var colors
    @Injected(\.fonts) private var fonts
    @Injected(\.images) private var images
    @Injected(\.utils) private var utils

    var factory: Factory
    @Binding var text: String
    @Binding var selectedRangeLocation: Int
    @Binding var command: ComposerCommand?
    var addedAssets: [AddedAsset]
    var addedFileURLs: [URL]
    var addedCustomAttachments: [CustomAttachment]
    var quotedMessage: Binding<ChatMessage?>
    var maxMessageLength: Int?
    var cooldownDuration: Int
    var onCustomAttachmentTap: (CustomAttachment) -> Void
    var removeAttachmentWithId: (String) -> Void

    @State var textHeight: CGFloat = TextSizeConstants.minimumHeight
    @State var keyboardShown = false

    public init(
        factory: Factory,
        text: Binding<String>,
        selectedRangeLocation: Binding<Int>,
        command: Binding<ComposerCommand?>,
        addedAssets: [AddedAsset],
        addedFileURLs: [URL],
        addedCustomAttachments: [CustomAttachment],
        quotedMessage: Binding<ChatMessage?>,
        maxMessageLength: Int? = nil,
        cooldownDuration: Int,
        onCustomAttachmentTap: @escaping (CustomAttachment) -> Void,
        removeAttachmentWithId: @escaping (String) -> Void
    ) {
        self.factory = factory
        _text = text
        _selectedRangeLocation = selectedRangeLocation
        _command = command
        self.addedAssets = addedAssets
        self.addedFileURLs = addedFileURLs
        self.addedCustomAttachments = addedCustomAttachments
        self.quotedMessage = quotedMessage
        self.maxMessageLength = maxMessageLength
        self.cooldownDuration = cooldownDuration
        self.onCustomAttachmentTap = onCustomAttachmentTap
        self.removeAttachmentWithId = removeAttachmentWithId
    }

    var textFieldHeight: CGFloat {
        let minHeight: CGFloat = TextSizeConstants.minimumHeight
        let maxHeight: CGFloat = TextSizeConstants.maximumHeight

        if textHeight < minHeight {
            return minHeight
        }

        if textHeight > maxHeight {
            return maxHeight
        }

        return textHeight
    }
    
    var inputPaddingsConfig: PaddingsConfig {
        utils.composerConfig.inputPaddingsConfig
    }

    public var body: some View {
        VStack {
            if let quotedMessage = quotedMessage.wrappedValue {
                factory.makeQuotedMessageView(
                    quotedMessage: quotedMessage,
                    fillAvailableSpace: true,
                    isInComposer: true,
                    scrolledId: .constant(nil)
                )
            }

            if !addedAssets.isEmpty {
                AddedImageAttachmentsView(
                    images: addedAssets,
                    onDiscardAttachment: removeAttachmentWithId
                )
                .transition(.scale)
                .animation(.default)
            }

            if !addedFileURLs.isEmpty {
                if !addedAssets.isEmpty {
                    Divider()
                }

                AddedFileAttachmentsView(
                    addedFileURLs: addedFileURLs,
                    onDiscardAttachment: removeAttachmentWithId
                )
                .padding(.trailing, 8)
            }
            
//            if !viewModel.addedVoiceRecordings.isEmpty {
//                AddedVoiceRecordingsView(
//                    addedVoiceRecordings: viewModel.addedVoiceRecordings,
//                    onDiscardAttachment: removeAttachmentWithId
//                )
//                .padding(.trailing, 8)
//                .padding(.top, 8)
//            }

            if !addedCustomAttachments.isEmpty {
                factory.makeCustomAttachmentPreviewView(
                    addedCustomAttachments: addedCustomAttachments,
                    onCustomAttachmentTap: onCustomAttachmentTap
                )
            }

            HStack {
                if let command = command,
                   let displayInfo = command.displayInfo,
                   displayInfo.isInstant == true {
                    HStack(spacing: 0) {
                        Image(uiImage: images.smallBolt)
                        Text(displayInfo.displayName.uppercased())
                    }
                    .padding(.horizontal, 8)
                    .font(fonts.footnoteBold)
                    .frame(height: 24)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }

                ZStack(alignment: .leading) {
                    TextField(
                        "",
                        text: $text
                    )
                    .font(.custom("FiraMono-Medium", size: 14))
                    .padding()
                    .background(colorsCus.backgroundColor)
                    .frame(height: 40)
                    .foregroundColor(colorsCus.textColor)
                    .cornerRadius(50)
                    
                    if text.isEmpty {
                        Text("Message")
                            .font(.custom("FiraMono-Medium", size: 14))
                            .padding(.leading, 20)
                            .foregroundColor(colorsCus.secondaryColor)
                            .frame(height: 40)
                            .cornerRadius(50)
                            .allowsHitTesting(false)
                    }
                }
                .accessibilityIdentifier("ComposerTextInputView")
                .accessibilityElement(children: .contain)
                .background(colorsCus.backgroundColor)
                .foregroundColor(colorsCus.textColor)
                .font(.custom("FiraMono-Medium", size: 14))
                .frame(height: textFieldHeight)
                .overlay(
                    command?.displayInfo?.isInstant == true ?
                        HStack {
                            Spacer()
                            Button {
                                self.command = nil
                            } label: {
                                DiscardButtonView(
                                    color: Color(colors.background7)
                                )
                            }
                        }
                        : nil
                )
            }
            .frame(height: textFieldHeight)
        }
        .padding(.vertical, shouldAddVerticalPadding ? inputPaddingsConfig.vertical : 0)
        .padding(.leading, inputPaddingsConfig.leading)
        .padding(.trailing, inputPaddingsConfig.trailing)
        .background(colorsCus.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: TextSizeConstants.cornerRadius)
                .stroke(Color(keyboardShown ? highlightedBorder : colors.innerBorder))
        )
        .clipShape(
            RoundedRectangle(cornerRadius: TextSizeConstants.cornerRadius)
        )
        .onReceive(keyboardWillChangePublisher) { visible in
            keyboardShown = visible
        }
        .accessibilityIdentifier("ComposerInputView")
    }

    private var composerInputBackground: Color {
        var colors = colors
        return Color(colors.composerInputBackground)
    }
    
    private var highlightedBorder: UIColor {
        var colors = colors
        return colors.composerInputHighlightedBorder
    }

    private var shouldAddVerticalPadding: Bool {
        !addedFileURLs.isEmpty || !addedAssets.isEmpty
    }

    private var isInCooldown: Bool {
        cooldownDuration > 0
    }
}

struct TextSizeConstants {
    static let composerConfig = InjectedValues[\.utils].composerConfig
    static let defaultInputViewHeight: CGFloat = 38.0
    static var minimumHeight: CGFloat {
        composerConfig.inputViewMinHeight
    }

    static var maximumHeight: CGFloat {
        composerConfig.inputViewMaxHeight
    }

    static var minThreshold: CGFloat {
        composerConfig.inputViewMinHeight
    }

    static var cornerRadius: CGFloat {
        composerConfig.inputViewCornerRadius
    }
}

