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
    @Published var isShowingUserListView = false
    @Published var searchText = ""
    @Published var users: [User] = []
    @Published var selectedUsers: [User] = []
    private var databaseReference = Firestore.firestore().collection("lists")

    init(list: ListModel) {
        self.list = list
        fetchList()
    }

    func fetchList() {
        let docRef = databaseReference.document(list.id!)

        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            do {
                self.list = try Firestore.Decoder().decode(ListModel.self, from: data)
            } catch {
                print("Error decoding document: \(error)")
            }
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
        list.listItems[index].completed.toggle()
        updateList()
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
}
