ChatApp using GetStream SDK and SwiftUI
A simple chat application built using the GetStream Chat SDK and SwiftUI for iOS.

Features
Real-time messaging
User authentication
Custom chat views with SwiftUI
Requirements
iOS 17.0+
Xcode 14+
Swift 5.0+
GetStream Chat SDK
Installation
GetStream Account:

Sign up at getstream.io and get your API Key.
Project Setup:

Clone this repository:
bash
Copy code
git clone https://github.com/Afraranver/Chat.git
Open the project in Xcode.
Add GetStream SDK:

Go to File > Add Packages... in Xcode.
Add the package: https://github.com/GetStream/stream-chat-swift.
Configure API Key:

In ChatApp.swift, add your API key:
swift
Copy code
import StreamChat

@main
struct ChatApp: App {
    init() {
        let config = ChatClientConfig(apiKey: .init("YOUR_API_KEY"))
        ChatClient.shared = ChatClient(config: config)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
Usage
Run the app on a simulator or device.
Sign in and start chatting!
