//
//  SpreadsheetDeleteRequestData.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 19/06/2022.
//

import Foundation


struct SpreadsheetDeleteRequest: Encodable {
    let ranges: [String]
}
