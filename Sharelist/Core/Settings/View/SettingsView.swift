//
//  SettingsView.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/10/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if let user = viewModel.currentUser {
                    List {
                        Section {
                            HStack {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray3))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.fullname)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .accentColor(.gray)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Section("Général") {
                            HStack {
                                SettingsRowView(imageName: "gear.circle",
                                                title: "Version",
                                                tintColor: Color(.systemGray))
                                
                                Spacer()
                                
                                Text("1.0.0")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        Section("Compte") {
                            Button {
                                viewModel.signOut()
                            } label: {
                                SettingsRowView(imageName: "arrow.left.circle.fill",
                                                title: "Sign Out",
                                                tintColor: Color(.systemRed))
                            }
                            
                            Button {
                                Task {
                                    try await viewModel.deleteAccount()
                                }
                            } label: {
                                SettingsRowView(imageName: "xmark.circle.fill",
                                                title: "Delete Account",
                                                tintColor: Color(.systemRed))
                            }
                        }
                    }
                }
            }
            
            if viewModel.isLoading {
                CustomProgressView()
            }
        }
    }
}

#Preview {
    SettingsView().environmentObject(AuthViewModel(currentUser: User.MOCK_USER))
}
