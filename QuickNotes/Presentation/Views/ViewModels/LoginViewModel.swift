//
//  LoginViewModel.swift
//  QuickNotes
//
//  Created by Khoa Mai on 25/4/24.
//

import Foundation
import SwiftUI
import Combine

enum StateLoginView {
    case loading
    case message(String)
    case success(String?)
}

class LoginViewModel {
    
    struct Input {
        let loginUserTrigger: AnyPublisher<String, Never>
    }
    
    struct Output {
        let state: AnyPublisher<StateLoginView, Never>
    }
    
    var userInfoUseCase: UserInfoUseCaseProtocol
    var stateSubject = PassthroughSubject<StateLoginView, Never>()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.userInfoUseCase = UserInfoUseCase(repository: UserInfoRepository())
    }
    
    init(userInfoUseCase: UserInfoUseCaseProtocol) {
        self.userInfoUseCase = userInfoUseCase
    }
    
    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
        input.loginUserTrigger
            .receive(on: DispatchQueue.main)
            .filter({ username in
                return !username.isEmpty
            })
            .sink { username in
                self.login(username: username)
            }.store(in: &cancellables)
        return LoginViewModel.Output(state: stateSubject.eraseToAnyPublisher())
    }
    
    func login(username: String) {
        userInfoUseCase.getUsers().sink { [weak self] completion in
            guard let self else {
                return
            }
            switch completion {
            case .failure(let error):
                self.stateSubject.send(.message(error.localizedDescription))
            case .finished:
                break
            }
        } receiveValue: { [weak self] users in
            let userInfo = users.first { userInfo in
                return userInfo.username == username
            }
            if let userInfo = userInfo {
                self?.stateSubject.send(.success(userInfo.userId))
            } else {
                self?.createUser(username: username)
            }
        }.store(in: &cancellables)
    }
    
    func createUser(username: String) {
        userInfoUseCase.createUser(UserInfo(username: username, createdAt: Date()))
            .sink { [weak self] completion in
            guard let self else {
                return
            }
            switch completion {
            case .failure(let error):
                self.stateSubject.send(.message(error.localizedDescription))
            case .finished:
                break
            }
        } receiveValue: { userId in
            self.stateSubject.send(.success(userId))
        }.store(in: &cancellables)
    }
    
}
