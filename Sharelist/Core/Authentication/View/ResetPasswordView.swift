//
//  ResetPasswordView.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/10/2023.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "list.clipboard.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height:120)
                .padding(.vertical, 32)
            
            InputView(text: $viewModel.email,
                      title: "Email",
                      placeholder: "Entrer l'adresse email associé à votre compte")
            .padding()
            .autocapitalization(.none)
            
            Button {
                viewModel.sendResetPasswordLink(toEmail: viewModel.email)
                dismiss()
            } label: {
                HStack {
                    Text("Réinitialiser")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding()
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Se connecter")
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    ResetPasswordView().environmentObject(AuthViewModel())
}
