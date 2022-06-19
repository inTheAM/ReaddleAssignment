//
//  MockGoogleSheetsService.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 14/06/2022.
//

import Combine
import Foundation
@testable import ReaddleAssignment

struct MockGoogleSheetsService: GoogleSheetsServiceProtocol {
    func fetchSpreadsheet() -> AnyPublisher<[FileItem], SheetError> {
        Just(FileItem.samples)
            .setFailureType(to: SheetError.self)
            .eraseToAnyPublisher()
    }
    
    func addItem(_ item: FileItem) -> AnyPublisher<FileItem?, SheetError> {
        Just(item)
            .setFailureType(to: SheetError.self)
            .eraseToAnyPublisher()
    }
    
    func deleteItem(_ item: FileItem) -> AnyPublisher<Bool, SheetError> {
        Just(true)
            .setFailureType(to: SheetError.self)
            .eraseToAnyPublisher()
    }
}
