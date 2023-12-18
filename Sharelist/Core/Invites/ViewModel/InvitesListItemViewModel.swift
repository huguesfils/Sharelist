//
//  InvitesListItemViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 14/12/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

@MainActor
class InvitesListItemViewModel: ObservableObject {
    @Published var list: ListModel
    @Published var currentUser: User?
    
    private var databaseReference = Firestore.firestore().collection("lists")
    
    
    init(list: ListModel) {
        self.list = list
        Task {
            await fetchUser()
        }
    }
    
    func toggleCompleted(for item: ListItem) {
        
        guard let index = list.listItems.firstIndex(where: { $0.id == item.id }) else { return }
        var currentItem = list.listItems[index]
        
        if !currentItem.completed && currentItem.completedBy == nil {
            currentItem.completed = true
            currentItem.completedBy = currentUser
        } else if currentItem.completed && (currentItem.completedBy == currentUser) {
            currentItem.completed = false
            currentItem.completedBy = nil
        } else {
            return
        }
        
        list.listItems[index] = currentItem
        
        updateList()
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    
    
    private func updateList() {
        do {
            let data = try Firestore.Encoder().encode(list)
            databaseReference.document(list.id!).setData(data)
        } catch {
            print("Error updating document: \(error)")
        }
    }
}
