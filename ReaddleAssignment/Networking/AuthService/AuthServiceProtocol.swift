//
//  AuthServiceProtocol.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 18/06/2022.
//

import Combine
import Foundation
import GoogleSignIn

protocol AuthServiceProtocol {
    /// The currently signed in user if exists.
    var user: GIDGoogleUser? { get }
    
    /// Sign's in a user using their google account.
    func signIn(presenting viewController: UIViewController) -> AnyPublisher<Bool, SignInError>
    
    /// Sign's out a user.
    func signOut() -> AnyPublisher<Bool, Never>
    
    /// Returns the access token associated with the currently signed in user.
    func tokenPublisher() -> AnyPublisher<String?, Never>
    
    /// Restores the session of the previously found user if sign-in had already been done.
    func restorePreviousSignInPublisher() -> AnyPublisher<Bool, Never>
    
}
