//
//  Manager.swift
//  ios
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import FirebaseFirestore

class FirebaseManager {
    private let db = Firestore.firestore()
    
    var database: Firestore { db }
    
    func create<T: Codable>(collection: String, object: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let _ = try db.collection(collection).addDocument(from: object) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    func read<T: Codable & Identifiable>(collection: String, completion: @escaping (Result<[T], Error>) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let objects = try snapshot?.documents.compactMap { document in
                        try document.data(as: T.self)
                    } ?? []
                    completion(.success(objects))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }

    func update<T: Codable & Identifiable>(collection: String, id: String, object: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection(collection).document(id).setData(from: object) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    func delete(collection: String, id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
