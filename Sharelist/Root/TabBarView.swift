//
//  TabBarView.swift
//  Sharelist
//
//  Created by Hugues Fils on 06/11/2023.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Label("Mes listes", systemImage: "list.bullet.circle")
                }
            
            InvitesListsView()
                .tabItem {
                    Label("Invitations", systemImage: "checklist")
                }
            
            SettingsView()
                .tabItem {
                    Label("Paramètres", systemImage: "gear")
                }
        }
    }
}

#Preview {
    TabBarView().environmentObject(AuthViewModel(currentUser: User.MOCK_USER))
}
