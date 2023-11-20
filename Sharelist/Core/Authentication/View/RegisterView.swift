//
//  RegisterView.swift
//  Sharelist
//
//  Created by Hugues Fils on 28/10/2023.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "list.clipboard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height:120)
                    .padding(.vertical, 32)
                
                VStack(spacing: 24) {
                    InputView(text: $viewModel.email,
                              title: "Email",
                              placeholder: "nom@exemple.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $viewModel.fullname,
                              title: "Nom complet",
                              placeholder: "Entrer votre nom complet")
                    
                    InputView(text: $viewModel.password,
                              title: "Mot de passe",
                              placeholder: "Entrer votre mot de passe",
                              isSecureField: true)
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $viewModel.confirmPassword,
                                  title: "Confirmer mot de passe",
                                  placeholder: "Confirmer votre mot de passe",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        
                        if !viewModel.password.isEmpty && !viewModel.confirmPassword.isEmpty {
                            if viewModel.password == viewModel.confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    Task {
                        try await viewModel.createUser(withEmail: viewModel.email, password: viewModel.password, fullname: viewModel.fullname)
                    }
                } label: {
                    HStack{
                        Text("S'enregister")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Vous avez un compte ?")
                        Text("Se connecter")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
            
            if viewModel.isLoading {
                CustomProgressView()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Erreur"),
                  message: Text(viewModel.authError?.description ?? ""))
        }
    }
}

extension RegisterView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
        && viewModel.confirmPassword == viewModel.password
        && !viewModel.fullname.isEmpty
    }
}

#Preview {
    RegisterView().environmentObject(AuthViewModel())
}
