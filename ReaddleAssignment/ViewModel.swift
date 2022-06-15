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
    private(set) var file: CurrentValueSubject<FileItem, Never>
    private(set) var error = PassthroughSubject<ErrorAlert?, Never>()

    private var cancellables = Set<AnyCancellable>()
    var onUpdate: (()->())?
    
    init(file: FileItem, service: GoogleSheetsServiceProtocol = GoogleSheetsService()) {
        self.file = .init(file)
        self.service = service
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if CommandLine.arguments.contains("MockData") {
            // Return mock data
            return 1
        } else {
            // Return actual data
            return file.value.children?.count ?? 0
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
            if let file = file.value.children?[indexPath.item] {
                let image = file.fileType == .file ? "doc.text" : "folder"
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
    
    func fetchSpreadsheet() {
        service.fetchSpreadsheet("1jHvPaLkwpWbnnWZ6KNN-HG1IEfpnP_v9i6noHIDVVQ8", range: "A:D")
            .receive(on: RunLoop.main)
            .catch { [weak self] error -> AnyPublisher<[FileItem], Never> in
                self?.error.send(.init(.failedToFetch))
                return Just([])
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] files in
                    self?.file.value.children = files
                
            }
            .store(in: &cancellables)
    }
    
    func addNewFileItem(_ item: FileItem) {
        service.addItems("1jHvPaLkwpWbnnWZ6KNN-HG1IEfpnP_v9i6noHIDVVQ8", items: item)
            .receive(on: RunLoop.main)
            .catch { [weak self] error -> AnyPublisher<[FileItem], Never> in
                self?.error.send(.init(.failedToAddItem))
                return Just([])
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] files in
                self?.file.value.children?.append(contentsOf: files)
            }
            .store(in: &cancellables)
    }
    
}


