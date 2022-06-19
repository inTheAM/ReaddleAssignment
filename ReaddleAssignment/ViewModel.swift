//
//  ViewModel.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import GoogleSignIn
import Combine
import UIKit
import SwiftUI

final class ViewModel: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Services
    private let sheetsService: GoogleSheetsServiceProtocol
    private let authService: AuthServiceProtocol
    
    // MARK: Data source
    /// The directory currently being shown.
    private(set) var file: CurrentValueSubject<FileItem, Never>
    
    /// An error if one occurs. Modeled as a PassthroughSubject thus never actually holds any data.
    private(set) var error = PassthroughSubject<ErrorAlert, Never>()
    
    /// The state of the user's session.
    private(set) var isSignedIn: CurrentValueSubject<Bool, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(file: FileItem, service: GoogleSheetsServiceProtocol = GoogleSheetsService(), authService: AuthServiceProtocol = AuthService()) {
        self.file = .init(file)
        self.sheetsService = service
        self.authService = authService
        isSignedIn = .init(authService.user != nil)
    }
    
    // MARK: - UICollectionViewDataSource conformance.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            file.value.children?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath) as! FileIcon
        
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
        return cell
    }
    
}

// MARK: - Sheets service methods.
extension ViewModel {
    /// Fetches the contents of a spreadsheet
    func fetchSpreadsheet() {
#if DEBUG
        if CommandLine.arguments.contains("MockData") {
            let file = FileItem(id: UUID(), range: "A1:D1", name: "file1.pdf", fileType: .file)
            self.file.send(.root(withChildren: [file]))
            return
        }
#endif
        
        sheetsService.fetchSpreadsheet()
            .receive(on: RunLoop.main)
            .catch { [weak self] error -> AnyPublisher<[FileItem], Never> in
                self?.error.send(.init(.failedToFetch))
                return Just([])
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] files in
                self?.file.send(.root(withChildren: files))
//                dump(self?.file.value.subItems().map(\.name), name: "SUBITEMS")
            }
            .store(in: &cancellables)
    }
    
    /// Adds a new file to the current directory and the network spreadsheet
    /// - Parameters:
    ///   - name: The name of the new file
    ///   - type: The type of the file ie file or folder
    func addNewFileItem(_ name: String, type: FileItem.FileType) {
        
        
#if DEBUG
        let newTestFile = FileItem(id: UUID(), parentID: file.value.id, range: "A2:D2", name: name, fileType: type, children: nil)
        if CommandLine.arguments.contains("MockData") {
            file.value.children?.append(newTestFile)
            file.send(file.value)
            return
        }
#endif
        
        // Creating the new file item and assigning a parent folder if one exists
        let newFile: FileItem
        if file.value.id == FileItem.rootDirectoryID {
            newFile = FileItem(id: UUID(), range: "", name: name, fileType: type)
        } else {
            newFile = FileItem(id: UUID(), parentID: file.value.id, range: "", name: name, fileType: type)
        }
        
        // Sending the new file to the spreadsheet
        sheetsService.addItem(newFile)
            .receive(on: RunLoop.main)
            .catch { [weak self] error -> AnyPublisher<FileItem?, Never> in
                self?.error.send(.init(.failedToAddItem))
                return Just(nil)
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] insertedFile in
                guard let self = self else { return }
                let file = self.file.value
                if let insertedFile = insertedFile {
                    if file.children != nil {
                        file.children?.append(insertedFile)
                    } else {
                        file.children = [insertedFile]
                    }
                }
//                print("SENDING FILE", file)
                self.file.send(file)
            }
            .store(in: &cancellables)
    }
    
    /// Deletes an entry from the current directory and the network spreadsheet
    /// - Parameter index: The index of the file to remove from the current directory.
    func delete(at index: Int) {
        
        #if DEBUG
        if CommandLine.arguments.contains("MockData") {
            file.value.children?.remove(at: index)
            file.send(file.value)
            return
        }
        #endif
        
        guard let itemToDelete = file.value.children?[index] else {
            return
        }
        sheetsService.deleteItem(itemToDelete)
            .receive(on: RunLoop.main)
            .catch { [weak self] error -> AnyPublisher<Bool, Never> in
                self?.error.send(.init(.failedToDeleteItem))
                return Just(false)
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] didDelete in
                guard let self = self else { return }
                if didDelete {
                    self.file.value.children?.remove(at: index)
                    self.file.send(self.file.value)
                }
            }
            .store(in: &cancellables)
        
    }
    
    /// Signs in a user using the auth service
    /// - Parameter viewController: The view controller to present when sign-in is complete.
    func signIn(presenting viewController: UIViewController) {
#if DEBUG
        if CommandLine.arguments.contains("MockData") {
            isSignedIn.send(true)
            return
        }
#endif
        authService.signIn(presenting: viewController)
            .catch { error -> AnyPublisher<Bool, Never> in
                self.error.send(ErrorAlert(error))
                return Just(false)
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .assign(to: \.isSignedIn.value, on: self)
            .store(in: &cancellables)
    }
    
    /// Signs out the current user.
    func signOut() {
#if DEBUG
        if CommandLine.arguments.contains("MockData") {
            isSignedIn.send(false)
            return
        }
#endif
        authService.signOut()
            .assign(to: \.isSignedIn.value, on: self)
            .store(in: &cancellables)
    }
    
    /// Restores the previous user's session if one exists.
    func restorePreviousSessionIfExists() {
        authService.restorePreviousSignInPublisher()
            .assign(to: \.isSignedIn.value, on: self)
            .store(in: &cancellables)
    }
    
    func validateSignInState() {
#if DEBUG
        if CommandLine.arguments.contains("SignedIn") {
            isSignedIn.send(true)
            return
        }
#endif
        isSignedIn.send(authService.user != nil)
    }
}




