//
//  UserInfoRepository.swift
//  QuickNotes
//
//  Created by Khoa Mai on 23/4/24.
//

import Foundation
import Combine

protocol UserInfoRepositoryProtocol {
    func loadUser(userId: String, child: String) -> AnyPublisher<UserInfo, Error>
    func create(userInfo: UserInfo, child: String) -> AnyPublisher<String?, Error>
    func fetch(child: String) -> AnyPublisher<[UserInfo], Error>
}

struct UserInfoRepository: UserInfoRepositoryProtocol {
    
    let firebaseService: FireBaseServiceProtocol
    init(firebaseService: FireBaseServiceProtocol = FireBaseService.shared) {
        self.firebaseService = firebaseService
    }
    
    func fetch(child: String) -> AnyPublisher<[UserInfo], Error> {
        return self.firebaseService.getAllDataOfChild(child: child)
    }
    
    func loadUser(userId: String, child: String) -> AnyPublisher<UserInfo, Error> {
        return self.firebaseService.getDataById(id: userId, child: child)
    }
    
    func create(userInfo: UserInfo, child: String) -> AnyPublisher<String?, Error> {
        return self.firebaseService.addDataChildObject(id: userInfo.userId, object: userInfo, child: child)
    }
}
