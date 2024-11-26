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
    
    func create<T: Codable>(
        collection: Collections,
        object: T,
        uniqueFields: [String]? = nil,
        uniqueValues: [Any]? = nil,
        customID: String? = nil
    ) async throws -> T {
        var q: Query = db.collection(collection.rawValue)
        
        if let uf = uniqueFields, let uv = uniqueValues, !uf.isEmpty && !uv.isEmpty && uf.count == uv.count {
            for (field, value) in zip(uf, uv) {
                q = q.whereField(field, isEqualTo: value)
            }
        }
        
        let snapshot = try await q.getDocuments()
        
        guard snapshot.isEmpty else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document already exist."])
        }
        
        do {
            let q = db.collection(collection.rawValue)

            if let id = customID {
                try q.document(id).setData(from: object)
            } else {
                try q.addDocument(from: object)
            }

            
            return object
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create document."])
        }
        
    }
    
    func read<T: Codable & Identifiable>(collection: Collections, id: String) async throws -> T {
        let snapshot = try await db.collection(collection.rawValue).document(id).getDocument()
        
        guard snapshot.exists else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found."])
        }
        
        let object = try snapshot.data(as: T.self)
        return object
    }
    
    
    func update<T: Codable & Identifiable>(collection: Collections, id: String, object: T) async throws {
        try db.collection(collection.rawValue).document(id).setData(from: object)
    }
    
    
    func delete(collection: Collections, id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection.rawValue).document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func findAll<T: Codable & Identifiable>(collection: Collections, ids: [UUID]? = nil) async throws -> [T] {
        var query: Query = db.collection(collection.rawValue)
        
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
    
    
    /// find all documents with simple 'where'
    /// - Parameters:
    ///   - collection: collection that you want to read
    ///   - tuple: key - value, tuple e.g ("name", "ABC")
    /// - Returns: object/s that will be selected
    func findAll<T: Codable & Identifiable>(collection: Collections, whereIs: (String, Any)) async throws -> [T] {
        let query: Query = db.collection(collection.rawValue).whereField(whereIs.0, isEqualTo: whereIs.1)
        
        let snapshot = try await query.getDocuments()
        
        let objects = try snapshot.documents.compactMap { document in
            try document.data(as: T.self)
        }
        return objects
    }
}
