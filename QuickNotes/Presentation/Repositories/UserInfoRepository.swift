//
//  UserInfoRepository.swift
//  QuickNotes
//
//  Created by Khoa Mai on 23/4/24.
//

import Foundation
import Combine

protocol UserInfoRepositoryProtocol {
    func loadUser(userId: String, child: String) -> Future<UserInfo, Error>
    func create(userInfo: UserInfo, child: String) -> Future<String?, Error>
}

struct UserInfoRepository: UserInfoRepositoryProtocol {
    
    let firebaseService: FireBaseServiceProtocol
    init(firebaseService: FireBaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
    
    func loadUser(userId: String, child: String) -> Future<UserInfo, Error> {
        return self.firebaseService.getDataById(id: userId, child: child)
    }
    
    func create(userInfo: UserInfo, child: String) -> Future<String?, Error> {
        return self.firebaseService.addDataChildObject(object: userInfo, child: child)
    }
    
}
