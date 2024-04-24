//
//  NoteListViewModel.swift
//  QuickNotes
//
//  Created by Khoa Mai on 22/4/24.
//

import Foundation
import Combine
import SwiftUI

enum LoadType {
    case invidual
    case all
}

enum StateView {
    case ide
    case loading
    case empty
    case error(String)
    case user(Bool)
    case note(String?)
    case notes([NoteInfo])
    case dismiss
}

class NoteListViewModel {
    
    var noteInfoUseCase: NoteInfoUseCaseProtocol
    var userInfoUseCase: UserInfoUseCaseProtocol
    
    @AppStorage("userId") var userId: String?
    private var userInfo: UserInfo?
    
    init(noteInfoUseCase: NoteInfoUseCaseProtocol, userInfoUseCase: UserInfoUseCaseProtocol) {
        self.noteInfoUseCase = noteInfoUseCase
        self.userInfoUseCase = userInfoUseCase
    }
    
    struct Input {
        let loadViewTrigger: AnyPublisher<Void, Never>
        let loadNotesTrigger: AnyPublisher<LoadType, Never>
        let loadUserTrigger: AnyPublisher<Void, Never>
        let addNoteTrigger: AnyPublisher<String, Never>
        let createUserTrigger: AnyPublisher<String, Never>
    }
    
    struct Output {
        let state: AnyPublisher<StateView, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    private var stateSubject = CurrentValueSubject<StateView, Never>.init(.ide)
    private var loadNoteInfoSubject = PassthroughSubject<[NoteInfo], Never>()
    
    func transform(input: NoteListViewModel.Input) -> NoteListViewModel.Output {
        
        input.loadViewTrigger
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.stateSubject.send(.ide)
            }.store(in: &cancellables)
        
        input.loadNotesTrigger
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                self?.loadNoteInfos(type: type)
            }.store(in: &self.cancellables)
        
        input.addNoteTrigger
            .filter({ content in
                return !content.isEmpty
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] content in
                self?.addNote(content: content)
            }.store(in: &cancellables)
        
        input.createUserTrigger
            .filter { username in
                return !username.isEmpty
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] username in
                self?.createUserName(username: username)
            }.store(in: &cancellables)
        
        input.loadUserTrigger
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadUserInfo()
            }.store(in: &cancellables)
        
        return NoteListViewModel.Output(
            state: stateSubject.eraseToAnyPublisher()
        )
    }
    
    func loadNoteInfos(type: LoadType) {
        stateSubject.send(.loading)
        noteInfoUseCase.getNotes(child: "note")
            .sink { [weak self] completion in
                guard let self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    self.stateSubject.send(.error(error.localizedDescription))
                case .finished:
                    break
                }
                self.stateSubject.send(.dismiss)
            } receiveValue: { [weak self] notes in
                guard let self else {
                    return
                }
                guard notes.count > 0 else {
                    self.stateSubject.send(.empty)
                    return
                }
                var newNotes = [NoteInfo]()
                if let userId = self.userId, type == .invidual {
                    newNotes = notes.filter({ noteInfo in
                        return userId == noteInfo.userId
                    })
                } else {
                    newNotes = notes
                }
                let sortedNotes = newNotes.sorted { noteInfo1, noteInfo2 in
                    return noteInfo1.createdAt > noteInfo2.createdAt
                }
                self.stateSubject.send(.notes(sortedNotes))
            }.store(in: &cancellables)
    }
    
    func addNote(content: String) {
        stateSubject.send(.loading)
        noteInfoUseCase.addNote(child: "note", userId: userId, userInfo: userInfo, content: content)
            .sink { [weak self] completion in
                guard let self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    self.stateSubject.send(.error(error.localizedDescription))
                case .finished:
                    break
                }
                self.stateSubject.send(.dismiss)
            } receiveValue: { noteId in
                self.stateSubject.send(.note(noteId))
            }.store(in: &cancellables)
    }
    
    func createUserName(username: String) {
        userInfoUseCase.createUser(UserInfo(username: username, createdAt: Date()))
            .sink { [weak self] completion in
                guard let self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    self.stateSubject.send(.error(error.localizedDescription))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] userId in
                self?.userId = userId
                self?.stateSubject.send(.user(false))
            }.store(in: &cancellables)
    }
    
    func loadUserInfo() {
        guard let userId = self.userId else {
            return
        }
        userInfoUseCase.loadUser(userId)
            .sink { [weak self] completion in
                guard let self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    self.stateSubject.send(.error(error.localizedDescription))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] userInfo in
                self?.userInfo = userInfo
                self?.stateSubject.send(.user(false))
            }.store(in: &cancellables)
    }
    
}

