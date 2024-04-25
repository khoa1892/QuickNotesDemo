//
//  NoteInfo.swift
//  QuickNotes
//
//  Created by Khoa Mai on 20/4/24.
//

import Foundation
import Combine

protocol NoteInfoUseCaseProtocol {
    func addNote(userInfo: UserInfo?, content: String) -> Future<String?, Error>
    func getNotes() -> Future<[NoteInfo], Error>
    func updateNewNotes() -> AnyPublisher<[NoteInfo], Error>
}

enum NoteError: Error {
    case invalidUserId
    case invalidUserInfo
}

class NoteInfoUseCase: NoteInfoUseCaseProtocol {
    
    let repository: NoteInfoRepositoryProtocol
    
    init(repository: NoteInfoRepositoryProtocol) {
        self.repository = repository
    }
    
    func addNote(userInfo: UserInfo?, content: String) -> Future<String?, Error> {
        guard let userInfo = userInfo else {
            return Future.init { promise in
                promise(.failure(NoteError.invalidUserInfo))
            }
        }
        let noteInfo = NoteInfo(content: content, userName: userInfo.username, userId: userInfo.userId, createdAt: Date())
        return self.repository.addNoteByChild(child: "note", noteInfo: noteInfo)
    }
    
    func getNotes() -> Future<[NoteInfo], Error> {
        return self.repository.getAllNotes(child: "note")
    }
    
    func updateNewNotes() -> AnyPublisher<[NoteInfo], Error> {
        return self.repository.updateNewNotes(child: "note")
    }
}
