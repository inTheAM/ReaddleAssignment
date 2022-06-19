//
//  MockAuthService.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 19/06/2022.
//

import Combine
import Foundation
import GoogleSignIn
@testable import ReaddleAssignment

struct MockAuthService: AuthServiceProtocol {
    var user: GIDGoogleUser?
    
    func signIn(presenting viewController: UIViewController) -> AnyPublisher<Bool, SignInError> {
        Just(true)
            .setFailureType(to: SignInError.self)
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Bool, Never> {
        Just(false)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
    
    func tokenPublisher() -> AnyPublisher<String?, Never> {
        Just("token")
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
    
    func restorePreviousSignInPublisher() -> AnyPublisher<Bool, Never> {
        Just(true)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
    
    
}

