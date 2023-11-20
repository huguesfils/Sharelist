//
//  List.swift
//  Sharelist
//
//  Created by Hugues Fils on 08/11/2023.
//

import FirebaseFirestoreSwift
import SwiftUI

struct ListModel: Codable, Identifiable {
    @DocumentID var id: String? // @DocumentID to fetch the identifier from Firestore
    var title: String
    var userId: String
    var listItems: [ListItem]
}

struct ListItem: Codable, Identifiable {
    var id: String
    var title: String
    var completed: Bool
}

#if DEBUG
let testListItemData = [
   ListItem(id: "", title: "item1", completed: true),
   ListItem(id: "", title: "item2", completed: false)
    ]
#endif
