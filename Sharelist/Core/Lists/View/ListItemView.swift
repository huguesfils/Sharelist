//
//  ListItemView.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import SwiftUI

struct ListItemView: View {
    @ObservedObject var viewModel: ListItemViewModel

    @State var presentNewItem = false
    
    var body: some View {
        ZStack{
            Color("CustomBackgroundColor").ignoresSafeArea()
            List {
                ForEach(viewModel.list.listItems) { item in
                    HStack {
                        TextField("Nouvel élément", text: item.title)
                        Spacer()
                        Image(systemName: item.completed ? "circle" : "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .onDelete(perform: viewModel.deleteListItem)
            }
            .navigationBarTitle(viewModel.list.title)
            .navigationBarItems(trailing: Button(action: {
                viewModel.addListItem()
            }) {
                Image(systemName: "plus")
            })
        }
    }
}

#Preview {
    ListItemView(viewModel: ListItemViewModel(list: ListModel(id: "1", title: "Test", userId: "", listItems: [ListItem(id: "", title: "Item1", completed: true)])))
}

