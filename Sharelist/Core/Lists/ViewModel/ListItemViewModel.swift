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
    @Published var shouldUpdateList = false
    
    private var dataController: DataController
    
    init(list: ListModel, dataController: DataController = DataController()) {
        self.list = list
        self.dataController = dataController
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
            dataController.fetchCurrentUser { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.currentUser = user
                    }
                case .failure(let error):
                    print("Error fetching user: \(error.localizedDescription)")
                }
            }
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
    
    func updateList() {
        dataController.updateList(list) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("List updated successfully")
            }
        }
    }
    
    func fetchUsers() {
        dataController.fetchUsers { result in
            switch result {
            case .success(let fetchedUsers):
                DispatchQueue.main.async {
                    self.users = fetchedUsers
                    print("update users with list")
                    print(self.users)
                }
            case .failure(let error):
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    func addGuest(userId: String) {
        if list.guests.contains(where: { $0 == userId}) {
            list.guests.removeAll(where: { $0 == userId })
        } else {
            list.guests.append(userId)
        }
        print("DEBUG: Guests => ",list.guests)
        shouldUpdateList = true
    }
}
