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
            .toolbar {
                           ToolbarItem(placement: .navigationBarTrailing) {
                               Button(action: {
                                   viewModel.addListItem()
                               }) {
                                   Image(systemName: "plus")
                               }
                           }
                           ToolbarItem(placement: .navigationBarTrailing) {
                               Button(action: {
                                   viewModel.isShowingUserListView = true
                               }) {
                                   Image(systemName: "square.and.arrow.up")
                               }
                           }
                       }
        }
        .sheet(isPresented: $viewModel.isShowingUserListView) {
           
                    VStack {
                        SearchBar(text: $viewModel.searchText)
                            .padding()
                        
                        List(viewModel.users.filter { $0.email.contains(viewModel.searchText) }) { user in
                            Button(action: {
                                viewModel.selectedUsers.append(user)
                            }) {
                                Text(user.email)
                            }
                        }
                    }
                    .onAppear {
                        viewModel.fetchUsers()
                    }
                
        }
    }
    private func deleteListItem(at offsets: IndexSet) {
        withAnimation {
            viewModel.deleteListItems(at: offsets)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ListItemView(viewModel: ListItemViewModel(list: ListModel(id: "1", title: "Test", userId: "", listItems: [ListItem(id: "", title: "Item1", completed: true)])))
}

