//
//  ListItemView.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import SwiftUI

struct ListItemView: View {
    @ObservedObject var viewModel: ListItemViewModel
    @State var isSheetVisible: Bool = false
    
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
                        
                        if let completedBy = item.completedBy {
                            VStack(alignment: .leading) {
                                Text(completedBy.fullname)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                                Text("s'en occupe !")
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 10))
                            }
                            
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
                        isSheetVisible = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $isSheetVisible) {
            NavigationStack{
                VStack {
                    List(viewModel.users.filter { $0.email.localizedCaseInsensitiveContains(viewModel.searchText) }) { user in
                        HStack {
                            Text(user.email)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.addGuest(userId: user.id)
                            }) {
                                Image(systemName: viewModel.list.guests.contains { $0 == user.id } ? "checkmark.circle.fill" : "plus")
                                    .foregroundColor(.blue)
                            }
                        }.listRowSeparator(.hidden)
                    }.listStyle(.plain)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Email")
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .onAppear {
                viewModel.fetchUsers()
            }
            .onDisappear {
                if viewModel.shouldUpdateList {
                    viewModel.updateList()
                    viewModel.shouldUpdateList = false
                }
            }
        }.background(
            Color("CustomBackgroundColor"))
    }
    
    private func deleteListItem(at offsets: IndexSet) {
        withAnimation {
            viewModel.deleteListItems(at: offsets)
        }
    }
}

#Preview {
    ListItemView(viewModel: ListItemViewModel(list: ListModel(id: "1", title: "Test", userId: "", listItems: [ListItem(id: "", title: "Item1", completed: true, completedBy: User(id: "1", fullname: "test test", email: "exemple@mail.com"))], guests: ["1234"])))
}

