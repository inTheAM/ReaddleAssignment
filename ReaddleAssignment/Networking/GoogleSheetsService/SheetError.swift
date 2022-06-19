//
//  SheetError.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 18/06/2022.
//

import Foundation

enum SheetError: String, Error {
    case failedToFetch,
         failedToAddItem,
    failedToDeleteItem
}
