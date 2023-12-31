//
//  DataController.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/12/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DataController {
    private let databaseReference = Firestore.firestore().collection("lists")
    
    func addDocument(_ document: Encodable, completion: @escaping (Error?) -> Void) {
        do {
            let _ = try databaseReference.addDocument(from: document)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    func fetchLists(forUserId userId: String, completion: @escaping (Result<[ListModel], Error>) -> Void) {
        let query = databaseReference.whereField("userId", isEqualTo: userId)
        
        query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let lists = documents.compactMap { queryDocumentSnapshot -> ListModel? in
                guard let listModel = try? queryDocumentSnapshot.data(as: ListModel.self) else {
                    return nil
                }
                return listModel
            }
            
            completion(.success(lists))
        }
    }
    
    func updateList(_ list: ListModel, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(list)
            databaseReference.document(list.id!).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func deleteList(withId id: String, completion: @escaping (Error?) -> Void) {
        databaseReference.document(id).delete { error in
            completion(error)
        }
    }
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user"])))
            return
        }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            do {
                let user = try Firestore.Decoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let fetchedUsers = documents.compactMap { document -> User? in
                do {
                    return try document.data(as: User.self)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    return nil
                }
            }
            
            completion(.success(fetchedUsers))
        }
    }
}
