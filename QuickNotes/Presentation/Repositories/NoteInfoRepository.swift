//
//  NoteInfoRepository.swift
//  QuickNotes
//
//  Created by Khoa Mai on 20/4/24.
//

import Foundation
import Combine
import FirebaseSharedSwift

protocol NoteInfoRepositoryProtocol {
    func getAllNotes(child: String) -> Future<[NoteInfo], Error>
    func addNoteByChild(child: String, noteInfo: NoteInfo) -> Future<String?, Error>
}

struct NoteInfoRepository: NoteInfoRepositoryProtocol {
    
    let firebaseService: FireBaseServiceProtocol
    init(firebaseService: FireBaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
    
    func getAllNotes(child: String) -> Future<[NoteInfo], Error> {
        return self.firebaseService.getAllDataOfChild(child: child)
    }
    
    func addNoteByChild(child: String, noteInfo: NoteInfo) -> Future<String?, Error> {
        return self.firebaseService.addDataChildObject(object: noteInfo, child: child)
    }
}
