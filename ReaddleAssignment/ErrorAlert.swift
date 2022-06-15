//
//  ErrorAlert.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 15/06/2022.
//

import Foundation

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
        }
    }
}
