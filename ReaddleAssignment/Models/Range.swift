//
//  Range.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 18/06/2022.
//

import Foundation

/// Represents a range of cells in A1 notation.
struct Range {
    static let all = Range("A:D")
    /// The row of the cell
    let row: String?
    
    /// The separator in the cell notation, typically a colon(:)
    let separator: String = ":"
    
    /// The column of the cell
    let column: String?
    
    /// The number identifying the position of the cell in row and column.
    let cellNumber: String?
    
    /// The A1 notation of the range.
    var a1Notation: String {
        if let row = row, let column = column {
            return row + (cellNumber ?? "") + separator + column + (cellNumber ?? "")
        } else {
            return ""
        }
    }
    
    /// Initializes the Range from a given A1 notation string.
    /// - Parameter a1NotationString: The string to parse for the cell properties.
    init(_ a1NotationString: String) {
        if !a1NotationString.isEmpty {
            let rowAndColumn = a1NotationString.replacingOccurrences(of: "Sheet1!", with: "").components(separatedBy: ":")
            let row = rowAndColumn[0]
            let column = rowAndColumn[1]
            let cellNumber = row.trimmingCharacters(in: .letters)
            
            self.row = row.trimmingCharacters(in: .decimalDigits)
            self.column = column.trimmingCharacters(in: .decimalDigits)
            self.cellNumber = cellNumber.isEmpty ? nil : cellNumber 
        } else {
            self.row = nil
            self.column = nil
            cellNumber = nil
        }
        print(self.a1Notation)
    }
}

// MARK: - Comparable conformance
extension Range: Comparable {
    static func <(lhs: Range, rhs: Range) -> Bool {
        if let lCell = Int(lhs.cellNumber ?? ""), let rCell = Int(rhs.cellNumber ?? "") {
            return lCell < rCell
        }
        return false
    }
}

// MARK: - Equatable conformance.
extension Range: Equatable {
    static func ==(lhs: Range, rhs: Range) -> Bool {
        lhs.a1Notation == rhs.a1Notation
    }
}
