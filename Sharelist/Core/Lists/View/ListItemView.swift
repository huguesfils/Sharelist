//
//  ListItemView.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import SwiftUI

struct ListItemView: View {
    @ObservedObject var viewModel: ListItemViewModel
    
    @State private var newItemTitle = ""
    
    var body: some View {
        ZStack{
            Color("CustomBackgroundColor").ignoresSafeArea()
            List {
                ForEach(viewModel.list.listItems) { item in
                    HStack {
                        TextField("New Item Title", text: $newItemTitle) {
                            viewModel.update
                        }
                        Spacer()
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .onDelete(perform: viewModel.deleteListItem)
                
            }
            .navigationBarTitle(viewModel.list.title)
            .navigationBarItems(trailing: Button(action: {
                let newListItem = ListItem(id: UUID().uuidString, title: newItemTitle, completed: false)
                viewModel.addListItem(newListItem)
                newItemTitle = ""
            }) {
                Image(systemName: "plus")
            })
        }
    }
}

#Preview {
    ListItemView(viewModel: ListItemViewModel(list: ListModel(id: "1", title: "Test", userId: "", listItems: [ListItem(id: "", title: "Item1", completed: true)])))
}

