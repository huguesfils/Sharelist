//
//  ListView.swift
//  Sharelist
//
//  Created by Hugues Fils on 20/11/2023.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel = ListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("CustomBackgroundColor").ignoresSafeArea()
                List {
                    ForEach(viewModel.lists, id:\.id) { list in
                        NavigationLink(destination: ListItemView(viewModel: ListItemViewModel(list: list))) {
                            VStack(alignment: .leading) {
                                if viewModel.isEditing {
                                    TextField("Nouveau titre", text: $viewModel.updatedTitle)
                                } else {
                                    Text(list.title).font(.system(size: 22, weight: .regular))
                                }
                                
                            }.frame(maxHeight: 200)
                        }
                    }.onDelete(perform: self.viewModel.deleteList(at:))
                    
                    Section{
                        Button {
                            viewModel.presentAlert = true
                        } label: {
                            Text("Ajouter une liste")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundStyle(.blue)
                        }.alert("Nouvelle liste", isPresented: $viewModel.presentAlert, actions: {
                            TextField("Nom de votre liste", text: $viewModel.title)
                            
                            Button("Enregistrer", action: {
                                self.viewModel.addList()
                                viewModel.title = ""
                            })
                            
                            Button("Annuler", role: .cancel, action: {
                                viewModel.presentAlert = false
                                viewModel.title = ""
                            })
                        })
                    }
                }
                .onAppear(perform: self.viewModel.fetchLists)
                .navigationTitle("Mes listes")
            }
        }
    }
}

#Preview {
    ListView()
}
