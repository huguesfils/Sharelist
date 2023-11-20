//
//  ListItemViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class ListItemViewModel: ObservableObject {
    @Published var list: ListModel
    private var listenerRegistration: ListenerRegistration?
    
    init(list: ListModel) {
        self.list = list
        fetchListItems()
    }
    
    private func fetchListItems() {
        let db = Firestore.firestore()
        listenerRegistration = db.collection("Lists").document(list.id!).collection("listItems").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.list.listItems = documents.compactMap { document in
                try? document.data(as: ListItem.self)
            }
        }
    }
    
    func addListItem() {
        let db = Firestore.firestore()
        let newListItem = ListItem(id: UUID().uuidString, title: "Nouvel Item", completed: false)
        
        do {
            _ = try db.collection("Lists").document(list.id!).collection("listItems").addDocument(from: newListItem)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func deleteListItem(at offsets: IndexSet) {
        let db = Firestore.firestore()
        
        offsets.forEach { index in
            let listItem = list.listItems[index]
            db.collection("Lists").document(list.id!).collection("listItems").document(listItem.id).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
    }
}
