//
//  FileItem.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

struct FileItem {
    
    enum FileType: String, Decodable {
        case file = "f", directory = "d"
    }
    
    let id: UUID
    var parentID: UUID?
    var name: String
    let fileType: String
    var children: [FileItem]?
}

extension FileItem: Codable {
    
}
