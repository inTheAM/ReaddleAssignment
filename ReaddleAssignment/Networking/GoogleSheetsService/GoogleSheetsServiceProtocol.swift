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
    /// - Returns: A publisher that publishes the files received and never fails.
    ///            In case of failure, an empty array is returned
    func fetchSpreadsheet(_ spreadsheetID: String, range: String) -> AnyPublisher<[FileItem], Never>
}
