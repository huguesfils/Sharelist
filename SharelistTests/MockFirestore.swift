//
//  MockFirestore.swift
//  SharelistTests
//
//  Created by Hugues Fils on 01/01/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MockFirestore {
    var documents: [String: [String: Any]] = [:]
    
    func addDocument(from document: Encodable) throws -> String {
        let documentData = try Firestore.Encoder().encode(document)
        let documentId = UUID().uuidString
        documents[documentId] = documentData
        return documentId
    }
    
    func document(_ documentPath: String) -> MockDocumentReference {
        return MockDocumentReference(path: documentPath, firestore: self)
    }
    
    func deleteDocument(_ documentPath: String) {
        documents[documentPath] = nil
    }
}

class MockDocumentReference {
    let path: String
    let firestore: MockFirestore
    
    init(path: String, firestore: MockFirestore) {
        self.path = path
        self.firestore = firestore
    }
    
    func setData(_ data: [String: Any], completion: @escaping (Error?) -> Void) {
        firestore.documents[path] = data
        completion(nil)
    }
    
    func delete(completion: @escaping (Error?) -> Void) {
        firestore.documents[path] = nil
        completion(nil)
    }
}

extension MockDocumentReference {
    func addSnapshotListener(_ listener: @escaping (MockDocumentSnapshot?, Error?) -> Void) {
        let snapshot = MockDocumentSnapshot(data: firestore.documents[path])
        listener(snapshot, nil)
    }
}

class MockDocumentSnapshot {
    let data: [String: Any]?
    
    init(data: [String: Any]?) {
        self.data = data
    }
    
    func data(as type: Decodable.Type) throws -> Any? {
        guard let data = data else {
            return nil
        }
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        let decodedData = try JSONDecoder().decode(type, from: jsonData)
        return decodedData
    }
}

