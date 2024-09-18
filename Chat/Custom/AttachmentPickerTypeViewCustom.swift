//
//  AttachmentPickerTypeViewCustom.swift
//  Chat
//
//  Created by Anver on 18/09/2024.
//

import SwiftUI
import StreamChatSwiftUI
import StreamChat

public struct AttachmentPickerTypeViewCustom: View {
    @Injected(\.images) private var images
    @Environment(\.colors) private var colors
    @Binding var pickerTypeState: PickerTypeState
    var channelConfig: ChannelConfig?

    private var commandsAvailable: Bool {
        channelConfig?.commands.count ?? 0 > 0
    }

    public init(
        pickerTypeState: Binding<PickerTypeState>,
        channelConfig: ChannelConfig?
    ) {
        _pickerTypeState = pickerTypeState
        self.channelConfig = channelConfig
    }

    public var body: some View {
        HStack(spacing: 16) {
            PickerTypeButtonCustom(
                pickerTypeState: $pickerTypeState,
                pickerType: .media,
                selected: .media
            )
            .accessibilityIdentifier("PickerTypeButtonCamera")
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
        .padding(.bottom, 8)
        .accessibilityElement(children: .contain)
    }
}

struct PickerTypeButtonCustom: View {
    @Injected(\.images) private var images
    @Environment(\.colors) private var colors

    @Binding var pickerTypeState: PickerTypeState

    let pickerType: AttachmentPickerType
    let selected: AttachmentPickerType

    var body: some View {
        Button {
            withAnimation {
                onTap(attachmentType: pickerType, selected: selected)
            }
        } label: {
            Image(uiImage: icon)
                .renderingMode(.template)
                .aspectRatio(contentMode: .fill)
                .frame(height: 24)
                .foregroundColor(
                    foregroundColor(for: pickerType, selected: selected)
                )
        }
    }

    private var icon: UIImage {
        if pickerType == .media {
            return images.attachmentPickerCamera
        } else {
            return UIImage()
        }
    }

    private func onTap(
        attachmentType: AttachmentPickerType,
        selected: AttachmentPickerType
    ) {
        pickerTypeState = pickerType == .media ? .expanded(pickerType) : .collapsed
    }

    private func foregroundColor(
        for pickerType: AttachmentPickerType,
        selected: AttachmentPickerType
    ) -> Color {
        if pickerType == selected {
            return Color(colors.accentColor)
        } else {
            return Color(colors.secondaryColor)
        }
    }
}
