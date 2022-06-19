//
//  SpreadsheetUpdateData.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 15/06/2022.
//

import Foundation

/// The data received when an update has been made to a spreadsheet.
struct SpreadsheetUpdateResponse: Decodable {
    
    /// The data that was updated
    let updates: UpdateData
    
    /// Contains the updated range of cells in the changes made to the spreadsheet.
    struct UpdateData: Decodable {
        let updatedRange: String
    }
}



