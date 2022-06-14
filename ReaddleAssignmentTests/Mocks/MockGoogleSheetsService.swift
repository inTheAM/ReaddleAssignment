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
    func fetchSpreadsheet(_ spreadsheetID: String, range: String) -> AnyPublisher<[FileItem], Never> {
        Just(FileItem.samples)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
}
