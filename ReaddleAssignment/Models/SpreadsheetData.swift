//
//  SpreadsheetData.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

struct SpreadsheetData: Decodable {
    let range: String
    let values: [[String]]
}
