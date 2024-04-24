//
//  NoteInfo.swift
//  QuickNotes
//
//  Created by Khoa Mai on 20/4/24.
//

import Foundation

class NoteInfoUseCase: NoteInfoProtocol {
    
    func createNote(userId: String, message: String) -> NoteInfo {
        return NoteInfo.init(noteId: "", userId: "", message: "", createAt: .init(), updateAt: .init())
    }
    
    func editNote(userId: String, noteId: String, message: String) -> NoteInfo {
        return NoteInfo.init(noteId: "", userId: "", message: "", createAt: .init(), updateAt: .init())
    }
    
    func fetchNotes(_ userId: String) -> [NoteInfo] {
        return [NoteInfo.init(noteId: "", userId: "", message: "", createAt: .init(), updateAt: .init())]
    }
}
