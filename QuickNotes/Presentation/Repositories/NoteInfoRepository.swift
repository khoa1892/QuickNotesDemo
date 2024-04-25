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
    func getAllNotes(child: String) -> AnyPublisher<[NoteInfo], Error>
    func getAllNotes(userId: String, queryOrderedByChild: String, child: String) -> AnyPublisher<[NoteInfo], Error>
    func addNoteByChild(child: String, noteInfo: NoteInfo) -> AnyPublisher<String?, Error>
    func updateNewNotes(child: String) -> AnyPublisher<[NoteInfo], Error>
    func updateNewNotes(userId: String, queryOrderedByChild: String, child: String) -> AnyPublisher<[NoteInfo], Error>
}

class NoteInfoRepository: NoteInfoRepositoryProtocol {
    
    let firebaseService: FireBaseServiceProtocol
    
    init(firebaseService: FireBaseServiceProtocol = FireBaseService.shared) {
        self.firebaseService = firebaseService
    }
    
    func getAllNotes(child: String) -> AnyPublisher<[NoteInfo], Error> {
        return self.firebaseService.getAllDataOfChild(child: child)
    }
    
    func getAllNotes(userId: String, queryOrderedByChild: String, child: String) -> AnyPublisher<[NoteInfo], any Error> {
        return self.firebaseService.getAllDataOfChildById(id: userId, queryOrderedByChild: queryOrderedByChild, child: child)
    }
    
    func addNoteByChild(child: String, noteInfo: NoteInfo) -> AnyPublisher<String?, Error> {
        return self.firebaseService.addDataChildObject(id: noteInfo.noteId, object: noteInfo, child: child)
    }
    
    func updateNewNotes(child: String) -> AnyPublisher<[NoteInfo], Error> {
        return self.firebaseService.observeNewData(child: child)
    }
    
    func updateNewNotes(userId: String, queryOrderedByChild: String, child: String) -> AnyPublisher<[NoteInfo], any Error> {
        return self.firebaseService.observeNewDataById(id: userId, queryOrderedbyChild: queryOrderedByChild, child: child)
    }
}
