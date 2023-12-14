//
//  InvitesListsView.swift
//  Sharelist
//
//  Created by Hugues Fils on 14/12/2023.
//

import SwiftUI

struct InvitesListsView: View {
    @ObservedObject var viewModel = InvitesListsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("CustomBackgroundColor").ignoresSafeArea()
                List {
                    ForEach(viewModel.lists, id:\.id) { list in
                        NavigationLink(destination: InvitesListItemView(viewModel: InvitesListItemViewModel(list: list))) {
                            VStack(alignment: .leading) {
                                
                                    Text(list.title).font(.system(size: 22, weight: .regular))
                                
                                
                            }.frame(maxHeight: 200)
                        }
                    }
                }
                .onAppear(perform: self.viewModel.fetchLists)
                .navigationTitle("Mes listes")
            }
        }
    }
}

#Preview {
    InvitesListsView()
}
