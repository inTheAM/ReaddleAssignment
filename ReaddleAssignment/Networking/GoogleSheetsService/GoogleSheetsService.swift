//
//  GoogleSheetsService.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Combine
import Foundation

/// A service for interacting with the Google Sheets API
struct GoogleSheetsService {
    
    ///The id of the spreadsheet being accessed
    private let spreadsheetID = "1jHvPaLkwpWbnnWZ6KNN-HG1IEfpnP_v9i6noHIDVVQ8"
    
    /// The range of cells to use in the spreadsheet
    private let range: Range = .all
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension GoogleSheetsService: GoogleSheetsServiceProtocol {
    
    func fetchSpreadsheet() -> AnyPublisher<[FileItem], SheetError> {
        print("RANGE:", range.a1Notation)
        return networkManager.performRequest(endpoint: .getSpreadsheet(spreadsheetID, range: range.a1Notation), requiresAuthorization: false, responseType: SpreadsheetData.self)
            .mapError { _ in
                    .failedToFetch
            }
            .map(\.values)
            .eraseToAnyPublisher()
    }
    
    func addItem(_ item: FileItem) -> AnyPublisher<FileItem?, SheetError> {
        let data = SpreadsheetData(range: range.a1Notation, values: [item])
        print(range.a1Notation)
        return networkManager.performRequest(endpoint: .addItem(spreadsheetID, range: range.a1Notation), requiresAuthorization: true, payload: data)
            .mapError{ _ in
                    .failedToAddItem
            }
            .map(\SpreadsheetUpdateData.updates)
            .map { updates in
                print(updates.updatedRange)
                let item = FileItem(id: item.id, parentID: item.parentID, range: updates.updatedRange, name: item.name, fileType: item.fileType, children: item.children)
                return item
            }
            .eraseToAnyPublisher()
    }
    
    func deleteItem(_ item: FileItem) -> AnyPublisher<Bool, SheetError> {
        let childRanges = item.flattened().map(\.range.a1Notation)
        let ranges = SpreadsheetDeleteData(ranges: [item.range.a1Notation] + childRanges)
        print(ranges)
        return networkManager.performRequest(endpoint: .deleteItem(spreadsheetID), requiresAuthorization: true, payload: ranges)
            .mapError { _ in
                    .failedToFetch
            }
            .map(\SpreadsheetClearData.clearedRanges.isEmpty)
            .map { !$0 }
            .eraseToAnyPublisher()
    }
}
