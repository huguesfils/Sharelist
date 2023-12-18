//
//  ListItemViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

@MainActor
class ListItemViewModel: ObservableObject {
    @Published var list: ListModel
    @Published var isShowingUserListView = false
    @Published var searchText = ""
    @Published var users: [User] = []
    @Published var completedByUsers: [String: User] = [:]
    @Published var currentUser: User?
    
    private var databaseReference = Firestore.firestore().collection("lists")
    
    init(list: ListModel) {
        self.list = list
        Task {
            await fetchUser()
        }
    }
    
    func addListItem() {
        let newListItem = ListItem(id: UUID().uuidString, title: "", completed: false)
        list.listItems.append(newListItem)
        updateList()
    }
    
    func updateListItemTitle(item: ListItem, title: String) {
        guard let index = list.listItems.firstIndex(where: { $0.id == item.id }) else { return }
        list.listItems[index].title = title
        updateList()
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
    
    func deleteListItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { index in
            list.listItems[index]
        }
        list.listItems.removeAll { item in
            itemsToDelete.contains { $0.id == item.id }
        }
        updateList()
    }
    
    private func updateList() {
        do {
            let data = try Firestore.Encoder().encode(list)
            databaseReference.document(list.id!).setData(data)
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
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
            
            DispatchQueue.main.async {
                self.users = fetchedUsers
            }
        }
    }
    
    func addGuest(userId: String) {
        if list.guests.contains(where: { $0 == userId}) {
            list.guests.removeAll(where: { $0 == userId })
            updateList()
        } else {
            list.guests.append(userId)
            updateList()
        }
        print("DEBUG: Guests => ",list.guests)
    }
}
