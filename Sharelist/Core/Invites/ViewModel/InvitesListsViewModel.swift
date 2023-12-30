//
//  InvitesListsViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 14/12/2023.
//

import FirebaseFirestore
import Firebase

class InvitesListsViewModel: ObservableObject {
    @Published var lists = [ListModel]()
    
    private var dataController: DataController
    
    init(dataController: DataController = DataController()) {
        self.dataController = dataController
        fetchLists()
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
    }}
