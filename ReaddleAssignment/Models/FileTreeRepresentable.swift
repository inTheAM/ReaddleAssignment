//
//  FileTreeRepresentable.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 15/06/2022.
//

import Foundation

/// A protocol for types that can be converted to and from`FileItem`s.
protocol FileTreeRepresentable {
    
    /// Decodes an aray of values from the GoogleSheets API into an array of `FileItem`
    /// - Parameter array: The values to convert to FileItem
    /// - Returns: The array of file items converted.
    static func decodeFiles(_ array: [Array<String>]) -> [FileItem]
    
    /// Encodes `FileItem` into the array of values that can be sent to the Google Sheets API.
    /// - Parameter files: The files to encode.
    /// - Returns: The array of values representing the item's properties.
    static func encodeFiles(_ files: [FileItem]) -> [Array<String>]
    
    /// Organizes a flat array of file items into a file tree.
    /// - Parameter files: The files to organize
    /// - Returns: An array containing top level elements with children sorted into parents.
    static func organize(_ files: [FileItem]) -> [FileItem]
}

// MARK: - Default implementations
extension FileTreeRepresentable {
    
    static func decodeFiles(_ array: [Array<String>]) -> [FileItem] {
        var index = 0
        return array.compactMap { fields -> FileItem? in
            if fields.first == nil || fields.first!.isEmpty {
                print("RETURNING NIL FOR INDEX \(index)")
                index += 1
                return nil
            }
            index += 1
            let id: String = fields[0]
            let parentID: String = fields[1]
            let fileType = FileItem.FileType(rawValue: fields[2])!
            let filename = fields[3]
            return FileItem(id: UUID(uuidString: id)!, parentID: UUID(uuidString: parentID), range: "A\(index):D\(index)", name: filename, fileType: fileType, children: fileType == .directory ? [] : nil)
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
    
    static func organize(_ files: [FileItem]) -> [FileItem] {
        
        // Files with parent folders
        let childFiles = files.filter { $0.parentID != nil && $0.fileType == .file }
        
        // All folders
        let allFolders = files.filter { $0.fileType == .directory }
        
        // Assigning child files to parent folders.
        for file in childFiles {
            if let parentFolderID = file.parentID,
               let parentFolderIndex = allFolders.firstIndex(where: { $0.id == parentFolderID }) {
                allFolders[parentFolderIndex].children?.append(file)
            }
        }
        
        // Files without parent folders
        let topLevelFiles = files.filter { $0.parentID == nil && $0.fileType == .file }
        
        // Folders without parent folders
        let topLevelFolders = allFolders.filter { $0.parentID == nil && $0.fileType == .directory }
        var childFolders = allFolders.filter { $0.parentID != nil }
        
        // Create file tree by assigning folders to parent folders.
        while !childFolders.isEmpty {
            for parent in topLevelFolders {
                parent.assignChildren(from: &childFolders)
            }
        }
        
        let organizedFiles = (topLevelFolders + topLevelFiles).sorted(by: {$0.range < $1.range})
        dump(organizedFiles)
        return organizedFiles
    }
}
