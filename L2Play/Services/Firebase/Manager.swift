//
//  Manager.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import FirebaseFirestore
import FirebaseAuth

class FirebaseManager {
    private let db = Firestore.firestore()
    
    
    // sign in with address email
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if authResult?.user != nil {
                completion(.success(()))
            }
            else {
                let unknownError = NSError(
                    domain: "FirebaseAuth",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Email or password are incorrect!"]
                )
                completion(.failure(unknownError))
            }
        }
    }
    
    
    func signIn(credential: AuthCredential, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            if result?.user != nil {
                completion(.success(()))
            } else {
                // new error
                let unknownError = NSError(
                    domain: "FirebaseAuth",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred during sign-in."]
                )
                completion(.failure(unknownError))
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                completion(.failure(err))
                return
            }
            if authResult?.user != nil {
                completion(.success(()))
            }
           else {
               let unknownError = NSError(
                   domain: "FirebaseAuth",
                   code: -1,
                   userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred during creating user."]
               )
               completion(.failure(unknownError))
            }
        }
    }
    
    func getOrCreateUser(user: FirebaseAuth.User, onlyGet: Bool = false, completion: @escaping (Result<User, Error>) -> Void) {
        let userRef = self.db.collection("users").document(user.email ?? user.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // create new obj when does not exists and func is called not only for get
            if let document = document, !document.exists {
                if onlyGet {
                    let noUserError = NSError(
                        domain: "FirebaseAuth",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No user found for email: \(user.email ?? user.uid)."]
                        )
                    completion(.failure(noUserError))
                    return
                } else {
                    let newUser = User(firebaseUser: user)
                    
                    do {
                        try userRef.setData(from: newUser) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(newUser))
                            }
                        }
                    } catch {
                        completion(.failure(error))
                    }
                    return
                }
            }
            
            do {
                let existingUser = try document?.data(as: User.self)
                if let existingUser = existingUser {
                    completion(.success(existingUser))
                } else {
                    completion(.failure(NSError(domain: "UserDecoding", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user data"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    
    func create<T: Codable>(
        collection: String,
        object: T,
        uniqueField: String,
        uniqueValue: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        db.collection(collection)
            .whereField(uniqueField, isEqualTo: uniqueValue)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let documents = querySnapshot?.documents, !documents.isEmpty {
                    let err = NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "Document with \(uniqueField) '\(uniqueValue)' already exists."])
                    
                    completion(
                        .failure(err)
                    )
                } else {
                    do {
                        let _ = try self.db.collection(collection).addDocument(from: object) { error in
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
            }
    }

    
    func read<T: Codable & Identifiable>(collection: String, id: String) async throws -> T {
        let snapshot = try await db.collection(collection).document(id).getDocument()
        
        guard snapshot.exists, let data = snapshot.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found."])
        }

        let object = try snapshot.data(as: T.self)
        return object
    }

    
    func update<T: Codable & Identifiable>(collection: String, id: String, object: T) async throws {
        try db.collection(collection).document(id).setData(from: object)
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
    
    func findAll<T: Codable & Identifiable>(collection: String, ids: [UUID]? = nil) async throws -> [T] {
        var query: Query = db.collection(collection)
        
        if let uids = ids {
            // no filters
            if uids.isEmpty {
                return []
            }
            
            let stringIds = uids.map { $0.uuidString }
            if !stringIds.isEmpty {
                query = query.whereField("id", in: stringIds)
            }
        }
        
        let snapshot = try await query.getDocuments()

        
        let objects = try snapshot.documents.compactMap { document in
            try document.data(as: T.self)
        }
        
        return objects
    }


}
