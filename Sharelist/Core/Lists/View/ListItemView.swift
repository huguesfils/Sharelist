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
                        )).onSubmit {
                            viewModel.addListItem()
                        }
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
                
                Section{
                    Button {
                        viewModel.addListItem()
                    } label: {
                        Text("Ajouter un élément").frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationBarTitle(viewModel.list.title)
            .toolbar {
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
                        
                        List(viewModel.users.filter { $0.email.localizedCaseInsensitiveContains(viewModel.searchText) }) { user in
                            HStack {
                                Text(user.email)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.addUser(user: user)
                                }) {
                                    Image(systemName: viewModel.selectedUsers.contains { $0.id == user.id } ? "checkmark.circle.fill" : "plus")
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.isShowingUserListView = false
                    }) {
                        Text("Fermer")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                }
                .onAppear {
                    viewModel.fetchUsers()
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

