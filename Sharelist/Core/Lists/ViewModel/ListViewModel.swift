//
//  ListViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import FirebaseFirestore
import Firebase

class ListViewModel: ObservableObject {
    @Published var lists = [ListModel]() // Reference to our Model
    @Published var title = ""
    @Published var presentAlert = false
    @Published var updatedTitle = ""
    @Published var isEditing = false
    
    private var databaseReference = Firestore.firestore().collection("lists")
    
    init(){
        fetchLists()
    }
    
    func addList() {
        guard canSave else {
            return
        }
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let newList = ListModel(title: title, userId: userId, listItems: [])
        do {
            let _ = try databaseReference.addDocument(from: newList)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        return true
    }
    
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
    
    func updateList(title: String, id: String) {
        databaseReference.document(id).updateData(["title" : title]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Note updated succesfully")
            }
        }
    }
    
    func deleteList(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let list = lists[index]
            databaseReference.document(list.id ?? "").delete { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("List with ID \(list.id ?? "") deleted")
                }
            }
        }
    }
}
