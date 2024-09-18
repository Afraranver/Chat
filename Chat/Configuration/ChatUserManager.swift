//
//  ChatUserManager.swift
//  Chat
//
//  Created by Anver on 16/09/2024.
//

import StreamChat
import Foundation

struct UserCredentials {
    let userInfo: UserInfo
    let token: Token
}

class ChatUserManager {
    private let chatClient: ChatClient
    
    init(chatClient: ChatClient) {
        self.chatClient = chatClient
    }
    
    private func getUserCredentials() -> UserCredentials {
        let userInfo = UserInfo(
            id: userId,
            name: userName,
            imageURL: URL(string: userImage)!
        )
        
        let token = try! Token(rawValue: userToken)
        
        return UserCredentials(userInfo: userInfo, token: token)
    }
    
    func connectUser() {
        let credentials = getUserCredentials()
        
        chatClient.connectUser(userInfo: credentials.userInfo, token: credentials.token) { error in
            if let error = error {
                log.error("Connecting the user failed: \(error.localizedDescription)")
                return
            }
            log.debug("User connected successfully")
        }
    }
}
