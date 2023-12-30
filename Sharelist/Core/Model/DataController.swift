//
//  DataController.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/12/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    func fetchLists() {
        let currentUser = Auth.auth().currentUser // Récupérer l'utilisateur en cours
        
        guard let currentUserId = currentUser?.uid else {
            print("No current user")
            return
        }
        
        let query = Firestore.firestore().collection("lists").whereField("userId", isEqualTo: currentUserId)
        
        query.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.lists = documents.compactMap { queryDocumentSnapshot -> ListModel? in
                guard let listModel = try? queryDocumentSnapshot.data(as: ListModel.self) else {
                    return nil
                }
                return listModel
            }
        }
    }
}
