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
    func addItems(_ spreadsheetID: String, items: FileItem...) -> AnyPublisher<[FileItem], SheetError> {
        Just(items)
            .setFailureType(to: SheetError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchSpreadsheet(_ spreadsheetID: String, range: String) -> AnyPublisher<[FileItem], SheetError> {
        Just(FileItem.samples)
            .setFailureType(to: SheetError.self)
            .eraseToAnyPublisher()
    }
}
