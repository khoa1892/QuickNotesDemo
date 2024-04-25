//
//  UserInfoUseCase.swift
//  QuickNotes
//
//  Created by Khoa Mai on 23/4/24.
//

import Foundation
import Combine

protocol UserInfoUseCaseProtocol {
    func createUser(_ userInfo: UserInfo) -> AnyPublisher<String?, Error>
    func loadUser(_ userId: String) -> AnyPublisher<UserInfo, Error>
    func getUsers() -> AnyPublisher<[UserInfo], Error>
}

struct UserInfoUseCase: UserInfoUseCaseProtocol {
    
    let repository: UserInfoRepositoryProtocol
    init(repository: UserInfoRepositoryProtocol) {
        self.repository = repository
    }
    
    func getUsers() -> AnyPublisher<[UserInfo], Error> {
        return self.repository.fetch(child: "user")
    }
    
    func createUser(_ userInfo: UserInfo) -> AnyPublisher<String?, Error> {
        return self.repository.create(userInfo: userInfo, child: "user")
    }
    
    func loadUser(_ userId: String) -> AnyPublisher<UserInfo, Error> {
        return self.repository.loadUser(userId: userId, child: "user")
    }
}
