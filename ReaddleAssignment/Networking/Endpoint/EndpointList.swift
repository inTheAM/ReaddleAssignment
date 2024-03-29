//
//  EndpointList.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

extension Endpoint {
    
    /// Creates an endpoint for fetching a spreadsheet from the google sheets api.
    /// - Parameters:
    ///   - spreadsheetID: The id of the spreadsheet as a `uuidString`
    ///   - range: The range of cells to request.
    /// - Returns: An endpoint containing the details required to fetch a spreadsheet from the google sheets api.
    static func getSpreadsheet(_ spreadsheetID: String, range: String) -> Endpoint {
        let path = "v4/spreadsheets/" + spreadsheetID + "/values/" + range
        return Endpoint(httpMethod: .get, path: path, queryItems: [URLQueryItem(name: "majorDimension", value: "ROWS")])
    }
    
    
    /// Creates an endpoint for adding items to the spreadsheet
    /// - Parameters:
    ///   - spreadsheetID: The id of the spreadsheet to update.
    ///   - range: The range of cells after which the new item will be added
    /// - Returns: An endpoint containing the details required to update a spreadsheet with a new value.
    static func addItem(_ spreadsheetID: String, range: String) -> Endpoint {
        let path = "v4/spreadsheets/" + spreadsheetID + "/values/" + range + ":append"
        return Endpoint(httpMethod: .post, path: path, queryItems: [URLQueryItem(name: "valueInputOption", value: "RAW")])
    }
    
    static func deleteItem(_ spreadsheetID: String) -> Endpoint {
        let path = "v4/spreadsheets/" + spreadsheetID + "/values/" + ":batchClear"
        return Endpoint(httpMethod: .post, path: path)
    }
}
