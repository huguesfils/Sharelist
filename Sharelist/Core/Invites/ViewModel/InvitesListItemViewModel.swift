//
//  InvitesListItemViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 14/12/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

class InvitesListItemViewModel: ObservableObject {
    @Published var list: ListModel
    
    private var databaseReference = Firestore.firestore().collection("lists")
    
    init(list: ListModel) {
        self.list = list
    }
    
    func toggleCompleted(for item: ListItem) {
        guard let index = list.listItems.firstIndex(where: { $0.id == item.id }) else { return }
        list.listItems[index].completed.toggle()
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
}
