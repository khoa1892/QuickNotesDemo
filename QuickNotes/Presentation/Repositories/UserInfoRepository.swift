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
    func fetch(child: String) -> Future<[UserInfo], Error>
}

struct UserInfoRepository: UserInfoRepositoryProtocol {
    
    let firebaseService: FireBaseServiceProtocol
    init(firebaseService: FireBaseServiceProtocol = FireBaseService.shared) {
        self.firebaseService = firebaseService
    }
    
    func fetch(child: String) -> Future<[UserInfo], Error> {
        return self.firebaseService.getAllDataOfChild(child: child)
    }
    
    func loadUser(userId: String, child: String) -> Future<UserInfo, Error> {
        return self.firebaseService.getDataById(id: userId, child: child)
    }
    
    func create(userInfo: UserInfo, child: String) -> Future<String?, Error> {
        return self.firebaseService.addDataChildObject(id: userInfo.userId, object: userInfo, child: child)
    }
}
