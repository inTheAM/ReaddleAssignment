//
//  FileTreeRepresentable.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 15/06/2022.
//

import Foundation

protocol FileTreeRepresentable {
    
}

extension FileTreeRepresentable {
    static func decodeFiles(_ array: [Array<String>]) -> [FileItem] {
        return array.map { fields -> FileItem in
            let id: String = fields[0]
            let parentID: String? = fields[1].isEmpty ? nil : fields[1]
            let fileType = FileItem.FileType(rawValue: fields[2])!
            let filename = fields[3]
            return FileItem(id: UUID(uuidString: id)!, parentID: UUID(uuidString: parentID ?? ""), name: filename, fileType: fileType)
        }
    }
    
    static func encodeFiles(_ files: [FileItem]) -> [Array<String>] {
        return files.map { file -> [String] in
            let id: String = file.id.uuidString
            let parentID: String = file.parentID?.uuidString ?? ""
            let fileType = file.fileType
            let filename = file.name
            return [id, parentID, fileType.rawValue, filename]
        }
    }
    
    private static func assignToParent(_ file: FileItem, to parentID: UUID, in parents: inout [FileItem]) {
        guard let index = parents.firstIndex(where: { $0.id == parentID })  else {
            fatalError("Parent does not exist!")
        }
        if parents[index].children == nil {
            parents[index].children = [file]
        } else {
            parents[index].children?.append(file)
        }
        
    }
    
    static func organize(_ files: [FileItem]) -> [FileItem] {
        
        var fileItems = [FileItem]()
        let allFolders = files.filter { $0.fileType == .directory }
        let allFiles = files.filter { $0.fileType == .file }
        
        fileItems.append(contentsOf: allFolders)
        
        // Assign each file to parent folder if existing
        for file in allFiles {
            if let parentID = file.parentID {
                assignToParent(file, to: parentID, in: &fileItems)
            } else {
                fileItems.append(file)
            }
        }
        
        // Assign folders to parent folders if existing.
        for (index, fileItem) in fileItems.enumerated() {
            if fileItem.fileType == .directory,
               let parentID = fileItem.parentID {
                assignToParent(fileItem, to: parentID, in: &fileItems)
                fileItems.remove(at: index)
            }
        }
        
        // Sort files by name and return
        fileItems.sort { $0.name < $1.name }
        
        return fileItems
    }
}
