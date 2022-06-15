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
    static let samples = [FileItem(id: exampleParentID, name: "Files", fileType: .directory, children: [.init(id: UUID(), parentID: exampleParentID, name: "file 1", fileType: .file), .init(id: UUID(), parentID: exampleParentID, name: "file2", fileType: .file)])]
}
