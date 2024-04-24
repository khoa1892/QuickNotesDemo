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
    init(firebaseService: FireBaseServiceProtocol = FireBaseService.shared) {
        self.firebaseService = firebaseService
    }
    
    func getAllNotes(child: String) -> Future<[NoteInfo], Error> {
        self.firebaseService.getAllDataOfChild(child: child)
    }
    
    func addNoteByChild(child: String, noteInfo: NoteInfo) -> Future<String?, Error> {
        self.firebaseService.addDataChildObject(object: noteInfo, child: child)
    }
}
