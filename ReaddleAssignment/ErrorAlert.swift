//
//  ErrorAlert.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 15/06/2022.
//

import Foundation

/// The content of an alert presented to the user in case of error
struct ErrorAlert {
    let title: String
    let message: String
    
    init(_ error: SheetError) {
        title = "Error"
        switch error {
        case .failedToFetch:
            message = "There was a problem fetching files."
        case .failedToAddItem:
            message = "Failed to add item."
        case .failedToDeleteItem:
            message = "Failed to delete item."
        }
    }
    
    init(_ error: SignInError) {
        title = "Error"
        switch error {
        case .scopesMissing:
            message = "Some authorization scopes are missing.\nEditing is disabled."
        case .userMissing:
            message = "User authentication failed."
        }
    }
}
