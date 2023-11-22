//
//  ListItemViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ListItemViewModel: ObservableObject {
    @Published var list: ListModel
    @Published var title = ""
    
    private var databaseReference = Firestore.firestore().collection("lists")
    
    init(list: ListModel) {
        self.list = list
        fetchList()
    }
    
    func fetchList() {
        let docRef = databaseReference.document(list.id!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func addListItem() {
        let newListItem = ListItem(id: UUID().uuidString, title: "", completed: false)
        let data = try! Firestore.Encoder().encode(newListItem)
        
        databaseReference.document(list.id!).updateData([
            "listItems": FieldValue.arrayUnion([data])
        ])
    }
    
    func deleteListItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let listItem = list.listItems[index]
            let data = try! Firestore.Encoder().encode(listItem)
            databaseReference.document(list.id!).updateData([
                "listItems": FieldValue.arrayRemove([data])
            ]) { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
    }
}
