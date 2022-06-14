//
//  ViewModel.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import Combine
import UIKit


final class ViewModel: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let service: GoogleSheetsServiceProtocol
    private(set) var file: FileItem
    private var cancellables = Set<AnyCancellable>()
    
    init(file: FileItem? = nil, service: GoogleSheetsServiceProtocol = GoogleSheetsService()) {
        if let file = file {
            self.file = file
        } else {
            self.file = FileItem(id: UUID(), name: "Files", fileType: "d", children: [])
        }
        self.service = service
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if CommandLine.arguments.contains("MockData") {
            // Return mock data
            return 1
        } else {
            // Return actual data
            return file.children?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath) as! FileIcon
        
        if CommandLine.arguments.contains("MockData") {
            // Return mock data
            switch FileExplorerLayout.layoutType {
            case .grid:
                cell.configure(axis: .vertical, image: "doc.text", name: "file.pdf")
            default:
                cell.configure(axis: .horizontal, image: "folder", name: "folder")
            }
        } else {
            // Return actual data
            if let file = file.children?[indexPath.item] {
                let image = file.fileType == "f" ? "doc.text" : "folder"
                switch FileExplorerLayout.layoutType {
                case .grid:
                    cell.configure(axis: .vertical, image: image, name: file.name)
                default:
                    cell.configure(axis: .horizontal, image: image, name: file.name)
                }
            }
        }
        
        
        return cell
    }
    
    func fetchSpreadsheet(_ completion: @escaping ()->()) {
        service.fetchSpreadsheet("1jHvPaLkwpWbnnWZ6KNN-HG1IEfpnP_v9i6noHIDVVQ8", range: "A:D")
            .receive(on: RunLoop.main)
            .sink { [weak self] files in
                self?.file.children = files
                completion()
            }
            .store(in: &cancellables)
        
    }
}

