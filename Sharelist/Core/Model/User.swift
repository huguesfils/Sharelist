//
//  User.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/10/2023.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "John Dorian", email: "test@test.com")
}
