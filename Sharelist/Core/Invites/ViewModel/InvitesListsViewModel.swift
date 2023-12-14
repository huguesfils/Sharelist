//
//  InvitesListsViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 14/12/2023.
//

import FirebaseFirestore
import Firebase

class InvitesListsViewModel: ObservableObject {
    @Published var lists = [ListModel]()
    
    private var databaseReference = Firestore.firestore().collection("lists")
    
    init(){
        fetchLists()
        print(lists)
    }
    
    func fetchLists() {
        let currentUser = Auth.auth().currentUser

        guard let currentUserId = currentUser?.uid else {
            print("No current user")
            return
        }
        
        let query = Firestore.firestore().collection("lists").whereField("guests", arrayContains: currentUserId)
        
        query.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.lists = documents.compactMap { queryDocumentSnapshot -> ListModel? in
                guard let listModel = try? queryDocumentSnapshot.data(as: ListModel.self) else {
                    print("error")
                    return nil
                }
                return listModel
            }
        }
    }
}
