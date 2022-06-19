//
//  SpreadsheetData.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

/// The data received when fetching a spreadsheet from the Google Sheets API.
struct SpreadsheetData: FileTreeRepresentable {
    
    /// The range of cells covered in the spreadsheet
    let range: String
    
    /// The values in the spreadsheet
    let values: [FileItem]
}

// MARK: - Codable conformance
extension SpreadsheetData: Codable {
    enum CodingKeys: String, CodingKey {
        case range = "range",
        values = "values"
    }
    
    /// Encodes the spreadsheet data to send over the network
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(range, forKey: .range)
        let stringValues = Self.encodeFiles(values)
        try container.encode(stringValues, forKey: .values)
    }
    
    /// Decodes spreadsheet data received from the network
    init(from decoder: Decoder) throws {
        let container    =    try    decoder.container(keyedBy: CodingKeys.self)
        range    =    try container.decode(String.self,    forKey:    .range)
        
        let stringValues = try container.decode([[String]].self, forKey: .values)
        let files = Self.decodeFiles(stringValues)
        let fileTree = Self.organize(files)
        
        values = fileTree
        
    }
}

#if DEBUG
extension SpreadsheetData {
    static let empty = SpreadsheetData(range: "", values: [])
}
#endif

