//
//  ListViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

class ListViewModel: ObservableObject {
    @Published var lists = [ListModel]() // Reference to our Model
    @Published var title = ""
    @Published var presentAlert = false
    @Published var updatedTitle = ""
    @Published var isEditing = false
    
    private var dataController: DataController
    
    init(dataController: DataController = DataController()) {
        self.dataController = dataController
        fetchLists()
    }
    
    func addList() {
        guard canSave else {
            return
        }
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let newList = ListModel(title: title, userId: userId, listItems: [], guests: [])
        dataController.addDocument(newList) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("List added successfully")
            }
        }
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        return true
    }
    
    func fetchLists() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user")
            return
        }
        
        dataController.fetchLists(forUserId: currentUserId) { [weak self] result in
            switch result {
            case .success(let lists):
                self?.lists = lists
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteList(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let list = lists[index]
            dataController.deleteList(withId: list.id ?? "") { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("List with ID \(list.id ?? "") deleted")
                }
            } 
        }
    }
}
