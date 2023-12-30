//
//  InvitesListItemViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 14/12/2023.
//

import Foundation

@MainActor
class InvitesListItemViewModel: ObservableObject {
    @Published var list: ListModel
    @Published var currentUser: User?
    
    private var dataController: DataController
    
    init(list: ListModel, dataController: DataController = DataController()) {
        self.list = list
        self.dataController = dataController
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
    
    private func updateList() {
        dataController.updateList(list) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("List updated successfully")
            }
        }
    }
}
