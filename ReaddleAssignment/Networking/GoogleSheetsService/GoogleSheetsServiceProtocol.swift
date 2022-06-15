//
//  GoogleSheetsServiceProtocol.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Combine
import Foundation

protocol GoogleSheetsServiceProtocol {
    /// Fetches the contents of a spreadsheet from the google sheets api as an array of files.
    /// - Parameters:
    ///   - spreadsheetID: The id of the spreadsheet to fetch
    ///   - range: The range of cells to fetch
    /// - Returns: A publisher that publishes the files received or an error if unsuccessful.
    func fetchSpreadsheet(_ spreadsheetID: String, range: String) -> AnyPublisher<[FileItem], SheetError>
    
    
    /// Adds entries to the spreadsheet.
    /// - Parameters:
    ///   - spreadsheetID: The id of the spreadsheet to modify.
    ///   - item: The item to add to the spreadsheet.
    /// - Returns: A publisher that publishes the files added to the spreadsheet or an error if unsuccessful.
    func addItems(_ spreadsheetID: String, items: FileItem...) -> AnyPublisher<[FileItem], SheetError>
    
}
