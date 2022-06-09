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
    
    private func organize(_ files: [FileItem]) -> [FileItem] {
        var fileItems = [FileItem]()
        var folders = files.filter { $0.fileType == FileItem.FileType.directory.rawValue }
        let filteredFiles = files.filter { $0.fileType == FileItem.FileType.file.rawValue }
        fileItems.append(contentsOf: folders)
        for file in filteredFiles {
            if let parentID = file.parentID {
                if let index = folders.firstIndex(where: { $0.id == parentID }) {
                    if folders[index].children == nil {
                        folders[index].children = [file]
                    } else {
                        folders[index].children?.append(file)
                    }
                }
            } else {
                fileItems.append(file)
            }
        }
        for (index, folder) in folders.enumerated() {
            if let parentID = folder.parentID {
                if let parentIndex = folders.firstIndex(where: { $0.id == parentID }) {
                    if folders[parentIndex].children == nil {
                        folders[parentIndex].children = [folder]
                    } else {
                        folders[parentIndex].children?.append(folder)
                    }
                    folders[parentIndex].children?.sort { $0.name < $1.name }
                }
                folders.remove(at: index)
            }
            
        }
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
