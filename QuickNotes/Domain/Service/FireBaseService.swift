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
    func getAllDataOfChild<T: Decodable>(child: String) -> Future<[T], Error>
    func getDataById<T: Decodable>(id: String, child: String) -> Future<T, Error>
    func addDataChildObject<T: Encodable>(object: T, child: String) -> Future<String?, Error>
}

struct FireBaseService: FireBaseServiceProtocol {
    
    static let shared = FireBaseService()
    
    func getAllDataOfChild<T: Decodable>(child: String) -> Future<[T], Error> {
        return Future { promise in
            let ref = Database.database().reference()
            ref.child(child).observeSingleEvent(of: .value) { snapshot in
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
                        promise(.failure(error))
                    }
                }
                promise(.success(data))
            }
        }
    }
    
    func getDataById<T: Decodable>(id: String, child: String) -> Future<T, Error> {
        return Future { promise in
            let ref = Database.database().reference().child(child).child(id)
            ref.observeSingleEvent(of: .value) { snapShot in
                guard snapShot.exists(), let value = snapShot.value as? [String: Any] else {
                    return
                }
                do {
                    let model = try FirebaseDataDecoder().decode(T.self, from: value)
                    promise(.success(model))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    func addDataChildObject<T: Encodable>(object: T, child: String) -> Future<String?, Error> {
        return Future { promise in
            do {
                let noteData = try FirebaseDataEncoder().encode(object)
                Database.database().reference().child(child).childByAutoId().setValue(noteData) { error, ref in
                    guard let error = error else {
                        promise(.success(ref.key))
                        return
                    }
                    promise(.failure(error))
                }
            } catch let error {
                promise(.failure(error))
            }
            
        }
    }
}
