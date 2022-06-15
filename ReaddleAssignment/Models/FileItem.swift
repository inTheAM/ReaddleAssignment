//
//  FileItem.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

struct FileItem: Identifiable, Equatable {
    static let rootDirectory = FileItem(id: UUID(), name: "Files", fileType: .directory, children: [])
    
    enum FileType: String, Decodable {
        case file = "f", directory = "d"
    }
    
    let id: UUID
    var parentID: UUID?
    var name: String
    let fileType: FileType
    var children: [FileItem]?
}
