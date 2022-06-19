//
//  FileItem.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

/// A tree data type for representing a user's file tree.
final class FileItem: Identifiable {
    
    /// The id of the file/folder
    let id: UUID
    
    /// The range of cells that represent the file in a spreadsheet
    let range: Range
    
    /// The id of the file's parent folder if it exists.
    var parentID: UUID?
    
    /// The name of the file/folder
    var name: String
    
    /// The type of file node ie file or directory
    let fileType: FileType
    
    /// The files that belong in this directory.
    /// Files cannot have children. ie Leaf nodes have `nil` children.
    var children: [FileItem]?
    
    init(id: UUID, parentID: UUID? = nil, range: String, name: String, fileType: FileItem.FileType, children: [FileItem]? = nil) {
        self.id = id
        self.parentID = parentID
        self.range = Range(range)
        self.name = name
        self.fileType = fileType
        self.children = children
    }
    
    /// Adds a new child to the children.
    /// - Parameter child: The new file to add.
    func add(child: FileItem) {
        children?.append(child)
    }
    
    /// Finds the parent of a given file if it exists.
    /// - Parameter parentID: The id of the parent to look for.
    /// - Returns: The parent matching the id given.
    func findParent(_ parentID: FileItem.ID?) -> FileItem? {
        if let index = children?.firstIndex(where: { $0.id == parentID }) {
            return children![index]
        }
        if let children = children {
            for child in children {
                if let match = child.findParent(parentID) {
                    return match
                }
            }
        }
        return nil
    }
    
    /// Assigns children to the correct parent folders within the hierarchy.
    /// - Parameter files: The files to sort .
    func assignChildren(from files: inout [FileItem]) {
        for (childIndex, file) in files.enumerated().reversed() {
            if file.parentID == id {
                add(child: file)
                files.remove(at: childIndex)
            } else {
                if let parent = findParent(file.parentID) {
                    parent.add(child: file)
                    files.remove(at: childIndex)
                }
            }
        }
    }
    func flattened() -> [FileItem] {
        if let children = children {
            return children.reduce(children) { partialResult, nextChild in
                partialResult + (nextChild.flattened())
            }
        } else {
            return []
        }
    }
}

extension FileItem {
    /// The type of file node
    enum FileType: String, Decodable {
        case file = "f", directory = "d"
    }
}

extension FileItem: Equatable {
    static func ==(lhs: FileItem, rhs: FileItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Root directory
extension FileItem {
    /// The id of the root directory.
    static let rootDirectoryID = UUID()
    
    /// The root directory, used to represent the top level items in the file hierarchy.
    static func root(withChildren children: [FileItem] = []) -> FileItem {
        return FileItem(id: rootDirectoryID, parentID: nil, range: "", name: "Files", fileType: .directory, children: children)
    }
}

