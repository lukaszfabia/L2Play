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
    
    
    /// Simple creating objects without checking
    /// - Parameters:
    ///   - collection: collection that you want to enrich by adding your new document
    ///   - object: model that you want to add
    /// - Returns: created object
    func create<T: Codable>(collection: Collections, object: T) throws -> T {
        do {
            try db.collection(collection.rawValue).addDocument(from: object)
            return object
        } catch {
            let error = NSError(
                domain: "Firestore",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to add object."])
            throw error
        }
    }
    
    func create<T: Codable>(
        collection: Collections,
        object: T,
        uniqueFields: [String]? = nil,
        uniqueValues: [Any]? = nil,
        customID: String
    ) async throws -> T {
        var q: Query = db.collection(collection.rawValue)
        
        if let uf = uniqueFields, let uv = uniqueValues, !uf.isEmpty && !uv.isEmpty && uf.count == uv.count {
            for (field, value) in zip(uf, uv) {
                q = q.whereField(field, isEqualTo: value)
            }
        }
        
        let snapshot = try await q.getDocuments()
        
        guard snapshot.isEmpty || uniqueFields == nil else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document already exist."])
        }
        
        do {
            let q = db.collection(collection.rawValue)
            
            try q.document(customID).setData(from: object)

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
        guard !id.isEmpty else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ID was not provided"])
        }
        
        let data = try Firestore.Encoder().encode(object)
        try await db.collection(collection.rawValue).document(id).setData(data)
    }
    
    
    func delete(collection: Collections, id: String)  {
       db.collection(collection.rawValue).document(id).delete()
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
    func findAll<T: Codable & Identifiable>(collection: Collections, whereIs: (String, Any), order: String? = nil) async throws -> [T] {
        var query: Query = db.collection(collection.rawValue).whereField(whereIs.0, isEqualTo: whereIs.1)
        if let o = order {
            query = query.order(by: o)
        }
        
        let snapshot = try await query.getDocuments()
        
        let objects = try snapshot.documents.compactMap { document in
            try document.data(as: T.self)
        }
        return objects
    }
}