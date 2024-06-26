//
//  NoteInfo.swift
//  QuickNotes
//
//  Created by Khoa Mai on 20/4/24.
//

import Foundation
import Combine

protocol NoteInfoUseCaseProtocol {
    func addNote(userInfo: UserInfo?, content: String) -> AnyPublisher<String?, Error>
    func getNotes(userId: String?, loadType: LoadType) -> AnyPublisher<[NoteInfo], Error>
    func updateNewNotes(userId: String?, loadType: LoadType) -> AnyPublisher<[NoteInfo], Error>
}

enum NoteError: Error {
    case invalidUserInfo
}

class NoteInfoUseCase: NoteInfoUseCaseProtocol {
    
    let repository: NoteInfoRepositoryProtocol
    
    init(repository: NoteInfoRepositoryProtocol) {
        self.repository = repository
    }
    
    func addNote(userInfo: UserInfo?, content: String) -> AnyPublisher<String?, Error> {
        guard let userInfo = userInfo else {
            return Fail(error: NoteError.invalidUserInfo).eraseToAnyPublisher()
        }
        let noteInfo = NoteInfo(content: content, userName: userInfo.username, userId: userInfo.userId, createdAt: Date())
        return self.repository.addNoteByChild(child: "note", noteInfo: noteInfo)
    }
    
    func getNotes(userId: String?, loadType: LoadType) -> AnyPublisher<[NoteInfo], Error> {
        if let userId = userId, loadType == .invidual {
            return self.repository.getAllNotes(userId: userId, queryOrderedByChild: "userId", child: "note")
        } else {
            return self.repository.getAllNotes(child: "note")
        }
    }
    
    func updateNewNotes(userId: String?, loadType: LoadType) -> AnyPublisher<[NoteInfo], Error> {
        if let userId = userId, loadType == .invidual {
            return self.repository.updateNewNotes(userId: userId, queryOrderedByChild: "userId", child: "note")
        } else {
            return self.repository.updateNewNotes(child: "note")
        }
    }
}
