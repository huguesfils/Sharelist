//
//  InvitesListItemView.swift
//  Sharelist
//
//  Created by Hugues Fils on 14/12/2023.
//

import SwiftUI

struct InvitesListItemView: View {
    @ObservedObject var viewModel: InvitesListItemViewModel
    
    var body: some View {
        ZStack {
            Color("CustomBackgroundColor").ignoresSafeArea()
            List {
                ForEach(viewModel.list.listItems, id: \.id) { item in
                    HStack {
                        Text(item.title)
                        
                        Spacer()
                        
                        if let completedBy = item.completedBy {
                            Text(completedBy.fullname)
                        }
                        
                        Button(action: {
                            viewModel.toggleCompleted(for: item)
                        }) {
                            Image(systemName: item.completed ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .navigationBarTitle(viewModel.list.title)
        }
    }
}

#Preview {
    InvitesListItemView(viewModel: InvitesListItemViewModel(list: ListModel(title: "1", listItems: [ListItem(title: "item", completed: false, completedBy: User(id: "1", fullname: "Test Test", email: "test@test.com"))], guests: ["1234"])))
}
