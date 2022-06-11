//
//  GoogleSheetsService.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Combine
import Foundation

struct GoogleSheetsService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    private func decodeFiles(_ array: [Array<String>]) -> [FileItem] {
        return array.map { fields -> FileItem in
            let id: String = fields[0]
            let parentID: String? = fields[1].isEmpty ? nil : fields[1]
            let fileType = fields[2]
            let filename = fields[3]
            return FileItem(id: UUID(uuidString: id)!, parentID: UUID(uuidString: parentID ?? ""), name: filename, fileType: fileType)
        }
    }
    
    private func assignToParent(_ file: FileItem, to parentID: UUID, in parents: inout [FileItem]) {
        guard let index = parents.firstIndex(where: { $0.id == parentID })  else {
            fatalError("Parent does not exist!")
        }
        if parents[index].children == nil {
            parents[index].children = [file]
        } else {
            parents[index].children?.append(file)
        }
        
    }
    
    private func organize(_ files: [FileItem]) -> [FileItem] {
        var fileItems = [FileItem]()
        let allFolders = files.filter { $0.fileType == FileItem.FileType.directory.rawValue }
        let allFiles = files.filter { $0.fileType == FileItem.FileType.file.rawValue }
        
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
            if fileItem.fileType == "d",
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

extension GoogleSheetsService: GoogleSheetsServiceProtocol {
    
    func fetchSpreadsheet(_ spreadsheetID: String, range: String) -> AnyPublisher<[FileItem], Never> {
        networkManager.performRequest(endpoint: .getSpreadsheet(spreadsheetID, range: range), responseType: SpreadsheetData.self)
            .catch { error -> AnyPublisher<SpreadsheetData, Never> in
                Just(SpreadsheetData(range: "", values: []))
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .map(\.values)
            .map(decodeFiles)
            .map(organize)
            .eraseToAnyPublisher()
    }
}
