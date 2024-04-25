//
//  FireBaseService.swift
//  QuickNotes
//
//  Created by Khoa Mai on 20/4/24.
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseSharedSwift
import Firebase
import FirebaseAuth

protocol FireBaseServiceProtocol {
    func getAllDataOfChild<T: Decodable>(child: String) -> AnyPublisher<[T], Error>
    func getDataById<T: Decodable>(id: String, child: String) -> AnyPublisher<T, Error>
    func addDataChildObject<T: Encodable>(id: String, object: T, child: String) -> AnyPublisher<String?, Error>
    func observeNewData<T: Decodable>(child: String) -> AnyPublisher<[T], Error>
}

struct FireBaseService: FireBaseServiceProtocol {
    
    static let shared = FireBaseService()
    
    init() {
        Database.database().isPersistenceEnabled = true
    }
    
    func getAllDataOfChild<T: Decodable>(child: String) -> AnyPublisher<[T], Error> {
        let subject = PassthroughSubject<[T], Error>()
        Database.database().reference().child(child).observeSingleEvent(of: .value) { snapshot in
            var data: [T] = []
            for note in snapshot.children {
                guard let snap = note as? DataSnapshot,
                      let value = snap.value else {
                    return
                }
                do {
                    let model = try FirebaseDataDecoder().decode(T.self, from: value)
                    data.append(model)
                } catch let error {
                    subject.send(completion: .failure(error))
                }
            }
            subject.send(data)
        }
        return subject.eraseToAnyPublisher()
    }
    
    func getDataById<T: Decodable>(id: String, child: String) -> AnyPublisher<T, Error> {
        let subject = PassthroughSubject<T, Error>()
        Database.database().reference().child(child).child(id).observeSingleEvent(of: .value) { snapShot in
            guard snapShot.exists(), let value = snapShot.value as? [String: Any] else {
                return
            }
            do {
                let model = try FirebaseDataDecoder().decode(T.self, from: value)
                subject.send(model)
            } catch let error {
                subject.send(completion: .failure(error))
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func addDataChildObject<T: Encodable>(id: String, object: T, child: String) -> AnyPublisher<String?, Error> {
        let subject = PassthroughSubject<String?, Error>()
        do {
            let noteData = try FirebaseDataEncoder().encode(object)
            Database.database().reference().child(child).child(id).setValue(noteData) { error, ref in
                guard let error = error else {
                    subject.send(ref.key)
                    return
                }
                subject.send(completion: .failure(error))
            }
        } catch let error {
            subject.send(completion: .failure(error))
        }
        return subject.eraseToAnyPublisher()
    }
    
    func observeNewData<T: Decodable>(child: String) -> AnyPublisher<[T], Error> {
        let notesTrigger = PassthroughSubject<[T], Error>()
        Database.database().reference().child(child).observe(.value) { snapshot in
            var data: [T] = []
            for note in snapshot.children {
                guard let snap = note as? DataSnapshot,
                        let value = snap.value else {
                    return
                }
                do {
                    let model = try FirebaseDataDecoder().decode(T.self, from: value)
                    data.append(model)
                } catch let error {
                    notesTrigger.send(completion: .failure(error))
                }
            }
            notesTrigger.send(data)
        }
        return notesTrigger.eraseToAnyPublisher()
    }
    
}
