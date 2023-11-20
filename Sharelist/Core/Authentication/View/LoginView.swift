//
//  LoginView.swift
//  Sharelist
//
//  Created by Hugues Fils on 27/10/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
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
                        
                        InputView(text: $viewModel.password,
                                  title: "Mot de passe",
                                  placeholder: "Entrer votre mot de passe",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        
                        NavigationLink {
                            ResetPasswordView()
                                .navigationBarHidden(true)
                        } label: {
                            Text("Mot de passe oublié ?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.blue)
                            
                        }
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    Button {
                        Task {
                            try await viewModel.signIn(withEmail: viewModel.email, password: viewModel.password)
                        }
                    } label: {
                        HStack{
                            Text("Se connecter")
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
                    
                    NavigationLink {
                        RegisterView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Text("Vous n'avez pas de compte ?")
                            Text("S'enregister")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Erreur"),
                          message: Text(viewModel.authError?.description ?? ""))
                }
                
                if viewModel.isLoading {
                    CustomProgressView()
                }
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
