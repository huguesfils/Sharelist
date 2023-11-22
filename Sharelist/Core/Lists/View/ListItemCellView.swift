//
//  ListItemCellView.swift
//  Sharelist
//
//  Created by Hugues Fils on 22/11/2023.
//

import SwiftUI

struct ListItemCellView: View {
    @ObservableObject var viewModel: ListItemCellViewModel
    
    var body: some View {
        HStack {
            TextField("Nouvel élément", text: $viewModel.list.item.title)
            Spacer()
            Image(systemName: item.completed ? "circle" : "checkmark.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    ListItemCellView()
}
