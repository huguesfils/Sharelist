//
//  List.swift
//  Sharelist
//
//  Created by Hugues Fils on 08/11/2023.
//

import FirebaseFirestoreSwift
import SwiftUI

struct ListModel: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var userId: String
    var listItems: [ListItem]
}

struct ListItem: Codable, Identifiable {
    var id: String
    var title: String
    var completed: Bool = false
}
