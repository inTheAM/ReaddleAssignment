//
//  AuthService.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 18/06/2022.
//

import Combine
import Foundation
import GoogleSignIn

struct AuthService: AuthServiceProtocol {
    private let signInConfig = GIDConfiguration(clientID: "457538325208-0qcmhvgcmbs9vk3n5qbi1kfal050c295.apps.googleusercontent.com")
    
    var user: GIDGoogleUser? {
        GIDSignIn.sharedInstance.currentUser
    }
    
    func signIn(presenting viewController: UIViewController) -> AnyPublisher<Bool, SignInError> {
        let scopes = ["https://www.googleapis.com/auth/drive",
                      "https://www.googleapis.com/auth/drive.file",
                      "https://www.googleapis.com/auth/spreadsheets"
        ]
        return Future { promise in
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: viewController, hint: nil, additionalScopes: scopes) { user, error in
                guard let user = user else {
                    promise(.failure(.userMissing))
                    return
                }
                scopes.forEach { scope in
                    guard let grantedScopes = user.grantedScopes,
                          grantedScopes.contains(scope) else {
                        promise(.failure(.scopesMissing))
                        return
                    }
                }
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func restorePreviousSignInPublisher() -> AnyPublisher<Bool, Never> {
        Future { promise in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, _ in
                if user == nil {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Bool, Never> {
        Future { promise in
            GIDSignIn.sharedInstance.signOut()
            promise(.success(false))
        }
        .eraseToAnyPublisher()
    }
    
    func tokenPublisher() -> AnyPublisher<String?, Never> {
        Future { promise in
            if let user = user {
                user.authentication.do { authentication, error in
                    return promise(.success(authentication?.accessToken))
                }
            } else {
                return promise(.success(nil))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
}
