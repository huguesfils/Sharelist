//
//  AuthError.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/10/2023.
//

import Foundation
import Firebase

enum AuthError: Error {
    case invalidEmail
    case invalidPassword
    case userNotFound
    case weakPassword
    case unknown
    
    init(authErrorCode: AuthErrorCode.Code) {
        switch authErrorCode {
        case .invalidEmail:
            self = .invalidEmail
        case .wrongPassword:
            self = .invalidPassword
        case .weakPassword:
            self = .weakPassword
        case .userNotFound:
            self = .userNotFound
        default:
            self = .unknown
        }
    }
    
    var description: String {
        switch self {
        case .invalidEmail:
            return "L'adresse e-mail que vous avez saisie est invalide. Veuillez réessayer."
        case .invalidPassword:
            return "Mot de passe incorrect. Veuillez réessayer."
        case .userNotFound:
            return "Il semble qu'il n'y ait aucun compte associé à cette adresse e-mail. Créez un compte pour continuer."
        case .weakPassword:
            return "Votre mot de passe doit comporter au moins 6 caractères. Veuillez réessayer."
        case .unknown:
            return "Une erreur inconnue s'est produite. Veuillez réessayer."
        }
    }
}
