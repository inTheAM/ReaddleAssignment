//
//  GoogleSheetsServiceProtocol.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Combine
import Foundation

protocol GoogleSheetsServiceProtocol {
    func fetchSpreadsheet(_ spreadsheetID: String, range: String) -> AnyPublisher<[FileItem], Never>
}
