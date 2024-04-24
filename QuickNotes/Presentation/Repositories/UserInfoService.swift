//
//  UserInfoService.swift
//  QuickNotes
//
//  Created by Khoa Mai on 20/4/24.
//

import Foundation

class UserInfoUseCase: UserInfoProtocol {
    
    func createUser(_ userName: String) -> UserInfo {
        return UserInfo.init(userName: "", userId: "", createdAt: Date())
    }
    
    func loadUser(_ userName: String) -> UserInfo {
        return UserInfo.init(userName: "", userId: "", createdAt: Date())
    }
}
