//
//  ContentView.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/10/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.currentUser != nil {
                TabBarView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel(currentUser: User.MOCK_USER))
}
