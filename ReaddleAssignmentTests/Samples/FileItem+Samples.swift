//
//  FileItem+Samples.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 14/06/2022.
//

import Foundation
@testable import ReaddleAssignment

extension FileItem {
    static let exampleParentID = UUID()
    static let samples = [FileItem(id: exampleParentID, range: "A1:D1", name: "Files", fileType: .directory, children: [.init(id: UUID(), parentID: exampleParentID, range: "A2:D2", name: "file 1", fileType: .file), .init(id: UUID(), parentID: exampleParentID, range: "A3:D3", name: "file2", fileType: .file)]), .init(id: UUID(), parentID: nil, range: "A4:D4", name: "file3", fileType: .file), .init(id: UUID(), parentID: exampleParentID, range: "A5:D5", name: "folder2", fileType: .file)]
}
