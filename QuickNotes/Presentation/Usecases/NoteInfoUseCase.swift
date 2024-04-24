//
//  NoteInfo.swift
//  QuickNotes
//
//  Created by Khoa Mai on 20/4/24.
//

import Foundation
import Combine

protocol NoteInfoUseCaseProtocol {
    func addNote(child: String, userId: String?, userInfo: UserInfo?, content: String) -> Future<String?, Error>
    func getNotes(child: String) -> Future<[NoteInfo], Error>
}

enum NoteError: Error {
    case invalidUserId
    case invalidUserInfo
}

struct NoteInfoUseCase: NoteInfoUseCaseProtocol {
    
    let repository: NoteInfoRepository
    init(repository: NoteInfoRepository) {
        self.repository = repository
    }
    
    func addNote(child: String, userId: String?, userInfo: UserInfo?, content: String) -> Future<String?, Error> {
        guard let userInfo = userInfo else {
            return Future.init { promise in
                promise(.failure(NoteError.invalidUserInfo))
            }
        }
        guard let userId = userId else {
            return Future.init { promise in
                promise(.failure(NoteError.invalidUserId))
            }
        }
        let noteInfo = NoteInfo(content: content, userName: userInfo.username, userId: userId, createdAt: Date())
        return self.repository.addNoteByChild(child: child, noteInfo: noteInfo)
    }
    
    func getNotes(child: String) -> Future<[NoteInfo], Error> {
        return self.repository.getAllNotes(child: child)
    }
}
