//
//  SpreadsheetData.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

struct SpreadsheetData: FileTreeRepresentable {
    let range: String
    let values: [FileItem]
}

extension SpreadsheetData: Codable {
    enum CodingKeys: String, CodingKey {
        case range = "range",
        values = "values"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(range, forKey: .range)
        let stringValues = Self.encodeFiles(values)
        try container.encode(stringValues, forKey: .values)
    }
    
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

