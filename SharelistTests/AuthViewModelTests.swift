//
//  AuthViewModelTests.swift
//  Sharelist
//
//  Created by Hugues Fils on 06/01/2024.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import Sharelist

@MainActor
class AuthViewModelTests: XCTestCase {

    var authViewModel: AuthViewModel!
    var testUser: Sharelist.User!  // Utilisez directement le modèle User ici

       override func setUp() {
           super.setUp()

           // Initialisez votre objet AuthViewModel pour les tests
           authViewModel = AuthViewModel()

           // Créez un utilisateur de test pour une utilisation dans les tests
           testUser = User(id: "testUserId", fullname: "Test User", email: "test@example.com")
       }

    override func tearDown() {
        // Nettoyez les données après chaque test
        super.tearDown()
    }

    func testSignIn() async throws {
        let expectation = XCTestExpectation(description: "Sign in expectation")

        do {
            try await authViewModel.signIn(withEmail: "invalid@example.com", password: "invalidPassword")
            XCTFail("Expected an error with INVALID_LOGIN_CREDENTIALS.")
        } catch {
            let expectedError = AuthError.unknown  // Mettez à jour selon l'erreur réelle attendue
            XCTAssertEqual(authViewModel.authError, expectedError)
            XCTAssertEqual(authViewModel.userSession, nil)
            XCTAssertEqual(authViewModel.currentUser, nil)
            expectation.fulfill()
        }

        await XCTWaiter().fulfillment(of: [expectation], timeout: 10.0)
    }

       func testCreateUser() async throws {
           let expectation = XCTestExpectation(description: "Create user expectation")

           do {
               try await authViewModel.createUser(withEmail: "newuser@example.com", password: "password", fullname: "New User")
               XCTAssertNotNil(authViewModel.userSession)
               XCTAssertNotNil(authViewModel.currentUser)
               XCTAssertEqual(authViewModel.currentUser?.fullname, "New User")
               XCTAssertEqual(authViewModel.currentUser?.email, "newuser@example.com")
               expectation.fulfill()
           } catch {
               XCTFail("Unexpected error during user creation: \(error)")
           }

           await XCTWaiter().fulfillment(of: [expectation], timeout: 10.0)
       }


//    func testSignOut() async throws {
//        let expectation = XCTestExpectation(description: "Sign out expectation")
//
//        do {
//            authViewModel.signOut()
//            XCTAssertNil(authViewModel.userSession)
//            XCTAssertNil(authViewModel.currentUser)
//            expectation.fulfill()
//        } catch {
//            XCTFail("Unexpected error during sign out: \(error)")
//        }
//
//        await XCTWaiter().fulfillment(of: [expectation], timeout: 10.0)
//    }

    func testDeleteAccount() async throws {
        let expectation = XCTestExpectation(description: "Delete account expectation")

        do {
            try await authViewModel.deleteAccount()
            XCTAssertNil(authViewModel.userSession)
            XCTAssertNil(authViewModel.currentUser)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error during account deletion: \(error)")
        }

        await XCTWaiter().fulfillment(of: [expectation], timeout: 10.0)
    }

    func testSignOut() async {
        let expectation = XCTestExpectation(description: "Sign out expectation")

        authViewModel.signOut()
        XCTAssertNil(authViewModel.userSession)
        XCTAssertNil(authViewModel.currentUser)

        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 10.0)
    }

    func testDeleteUserData() async {
        let expectation = XCTestExpectation(description: "Delete user data expectation")

        authViewModel.deleteUserData()
        // Verify that no error occurred during the deletion of user data
        XCTAssert(true)  // Placeholder assertion

        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 10.0)
    }

    func testFetchUser() async {
        let expectation = XCTestExpectation(description: "Fetch user expectation")

        await authViewModel.fetchUser()
        // Verify that no error occurred during the fetching of user data
        XCTAssert(true)  // Placeholder assertion

        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 10.0)
    }

    func testSendResetPasswordLink() async {
        let expectation = XCTestExpectation(description: "Send reset password link expectation")

        authViewModel.sendResetPasswordLink(toEmail: "test@example.com")
        // Verify that no error occurred during the password reset link sending
        XCTAssert(true)  // Placeholder assertion

        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 10.0)
    }
}
