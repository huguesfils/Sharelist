//
//  ListItemView.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import SwiftUI

struct ListItemView: View {
    @ObservedObject var viewModel: ListItemViewModel
    
    var body: some View {
        ZStack {
            Color("CustomBackgroundColor").ignoresSafeArea()
            List {
                ForEach(viewModel.list.listItems, id: \.id) { item in
                    HStack {
                        TextField("Nouvel élément", text: Binding(
                            get: { item.title },
                            set: { title in
                                viewModel.updateListItemTitle(item: item, title: title)
                            }
                        ), onCommit: {
                            viewModel.updateListItemTitle(item: item, title: item.title)
                        })
                        Spacer()
                        Button(action: {
                            viewModel.toggleCompleted(for: item)
                        }) {
                            Image(systemName: item.completed ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .onDelete(perform: deleteListItem)
            }
            .navigationBarTitle(viewModel.list.title)
            .navigationBarItems(trailing: Button(action: {
                viewModel.addListItem()
            }) {
                Image(systemName: "plus")
            })
        }
    }
    private func deleteListItem(at offsets: IndexSet) {
        withAnimation {
            viewModel.deleteListItems(at: offsets)
        }
    }
}

#Preview {
    ListItemView(viewModel: ListItemViewModel(list: ListModel(id: "1", title: "Test", userId: "", listItems: [ListItem(id: "", title: "Item1", completed: true)])))
}

