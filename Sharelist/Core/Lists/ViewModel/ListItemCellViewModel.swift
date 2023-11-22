//
//  ListItemCellViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 22/11/2023.
//

import Foundation

class ListItemCellViewModel: ObservableObject, Identifiable {
    @Published var listItem: ListItem
    
}
