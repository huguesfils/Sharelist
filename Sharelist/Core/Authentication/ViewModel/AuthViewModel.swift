//
//  AuthViewModel.swift
//  Sharelist
//
//  Created by Hugues Fils on 28/10/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var authError: AuthError?
    @Published var showAlert = false
    @Published var isLoading = false
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var confirmPassword = ""
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init(currentUser: User? = nil) {
        self.userSession = Auth.auth().currentUser
        self.currentUser = currentUser
        print("DEBUG LOG:", userSession as Any)
        print("DEBUG LOG:", currentUser as Any)
        Task {
            isLoading = true
            await fetchUser()
            isLoading = false
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        isLoading = true
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            isLoading = false
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
            isLoading = false
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        isLoading = true
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            try await db.collection("users").document(result.user.uid).setData(encodedUser)
            await fetchUser()
            isLoading = false
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
            isLoading = false
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            self.currentUser = nil
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        do {
            deleteUserData()
            try await auth.currentUser?.delete()
            self.currentUser = nil
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
        }
    }
    
    func deleteUserData() {
        guard let uid = auth.currentUser?.uid else { return }
        db.collection("users").document(uid).delete()
    }
    
    func sendResetPasswordLink(toEmail email: String) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("DEBUG: Error sending password reset link : \(error.localizedDescription)")
            } else {
                print("DEBUG: Password reset link sent successfully")
            }
        }
    }
    
    func fetchUser() async {
        guard let uid = auth.currentUser?.uid else { return }
        guard let snapshot = try? await db.collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
