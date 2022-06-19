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
    func fetchSpreadsheet() -> AnyPublisher<[FileItem], SheetError>
    
    
    /// Adds entries to the spreadsheet.
    /// - Parameters:
    ///   - spreadsheetID: The id of the spreadsheet to modify.
    ///   - item: The item to add to the spreadsheet.
    /// - Returns: A publisher that publishes the files added to the spreadsheet or an error if unsuccessful.
    func addItem(_ item: FileItem) -> AnyPublisher<FileItem?, SheetError>
    
    
    /// Deletes the item and its children from the spreadsheet
    /// - Parameter item: The item to delete.
    /// - Returns: A publisher that publishes a boolean indicating whether the deletion was successful or not
    func deleteItem(_ item: FileItem) -> AnyPublisher<Bool, SheetError>
}
