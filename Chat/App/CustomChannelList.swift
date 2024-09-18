//
//  CustomChannelList.swift
//  Chat
//
//  Created by Anver on 16/09/2024.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct CustomChannelList: View {
    @StateObject private var viewModel: ChatChannelListViewModel
    @StateObject private var channelHeaderLoader = ChannelHeaderLoader()
    
    private var colors: ColorPaletteCustom {
        ColorPaletteCustom.defaultPalette
    }

    init(channelListController: ChatChannelListController? = nil) {
        _viewModel = StateObject(
            wrappedValue: ViewModelsFactory.makeChannelListViewModel(
                channelListController: channelListController,
                selectedChannelId: nil
            )
        )
    }
    
    var body: some View {
        NavigationView {
            ChannelList(
                factory: CustomFactory.shared,
                channels: viewModel.channels,
                selectedChannel: $viewModel.selectedChannel,
                swipedChannelId: $viewModel.swipedChannelId,
                onItemTap: { channel in
                    viewModel.selectedChannel = channel.channelSelectionInfo
                },
                onItemAppear: { index in
                    viewModel.checkForChannels(index: index)
                },
                channelDestination: CustomFactory.shared.makeChannelDestination()
            )
            .background(colors.backgroundColor)
            .toolbar {
                toolbarContent()
            }
        }
    }

    // MARK: - Toolbar Content
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text("Connections")
                .font(.custom("FiraMono-Bold", size: 20))
                .foregroundColor(colors.textColor)
                .padding(.top, 20)
        }
    }
}

// MARK: - Previews
struct CustomChannelList_Previews: PreviewProvider {
    static var previews: some View {
        CustomChannelList()
            .previewLayout(.sizeThatFits)
    }
}
