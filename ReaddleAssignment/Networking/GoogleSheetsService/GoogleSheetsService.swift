//
//  GoogleSheetsService.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Combine
import Foundation

enum SheetError: String, Error {
    case failedToFetch,
    failedToAddItem
}

struct GoogleSheetsService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension GoogleSheetsService: GoogleSheetsServiceProtocol {
    
    func fetchSpreadsheet(_ spreadsheetID: String, range: String) -> AnyPublisher<[FileItem], SheetError> {
        networkManager.performRequest(endpoint: .getSpreadsheet(spreadsheetID, range: range), responseType: SpreadsheetData.self)
            .mapError { _ in
                    .failedToFetch
            }
            .map(\.values)
            .eraseToAnyPublisher()
    }
    
    func addItems(_ spreadsheetID: String, items: FileItem...) -> AnyPublisher<[FileItem], SheetError> {
        let data = SpreadsheetData(range: "A:D", values: items)
        return networkManager.performRequest(endpoint: .addItem(spreadsheetID, range: "A:D"), payload: data)
            .mapError{ _ in
                    .failedToAddItem
            }
            .map(\SpreadsheetUpdateData.updatedData.values)
            .eraseToAnyPublisher()
    }
}
