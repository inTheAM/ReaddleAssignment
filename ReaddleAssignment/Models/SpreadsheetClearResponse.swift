//
//  SpreadsheetClearData.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 19/06/2022.
//

import Foundation

struct SpreadsheetClearResponse: Decodable {
    let spreadsheetId: String
    let clearedRanges: [String]
}
