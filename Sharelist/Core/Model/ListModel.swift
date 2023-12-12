//
//  List.swift
//  Sharelist
//
//  Created by Hugues Fils on 08/11/2023.
//

import FirebaseFirestore
import SwiftUI

struct ListModel: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var userId: String?
    var listItems: [ListItem]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case userId
        case listItems
    }
}

struct ListItem: Codable, Identifiable {
    var id: String?
    var title: String
    var completed: Bool = false
}
