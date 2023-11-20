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
        ZStack{
            Color("CustomBackgroundColor").ignoresSafeArea()
            Text("hello world!")
                    List {
                        ForEach(viewModel.list.listItems) { item in
                            Text(item.title)
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
//    ListItemView(viewModel: ListItemViewModel(list: ListModel(title: "Test", userId: "", listItems: [ListItem(id: "", title: "Item1", completed: true)])))
    ListItemView(viewModel: ListItemViewModel(list: ListModel(title: "Test", userId: "", listItems: [ListItem(id: "", title: "Item1", completed: true)])))
}
 
