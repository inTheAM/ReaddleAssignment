//
//  ViewModelTests.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import Combine
import XCTest
@testable import ReaddleAssignment

class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    override func setUpWithError() throws {
        viewModel = ViewModel(file: .root(), service: MockGoogleSheetsService())
        dump(viewModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchingSpreadsheet() throws {
        let fetchedFilePublisher = viewModel.file
            .dropFirst()
            .first()
        
        viewModel.fetchSpreadsheet()
        
        let file = try awaitResult(from: fetchedFilePublisher)
        XCTAssertEqual(file.children?[0].id, FileItem.samples[0].id)
    }

    func testAddingItem() throws {
        let addedItemPublisher = viewModel.file
            .dropFirst()
            .first()
        
        viewModel.addNewFileItem("file3.pdf", type: .file)
        
        let file = try awaitResult(from: addedItemPublisher)
        XCTAssertEqual(file.children?[0].name, "file3.pdf")
    }

    func testDeletingItem() throws {
        let addedItemPublisher = viewModel.file
            .dropFirst()
            .first()
        
        viewModel.addNewFileItem("file3.pdf", type: .file)
        
        _ = try awaitResult(from: addedItemPublisher)
        
        let deletedItemPublisher = viewModel.file
            .dropFirst()
            .first()
        
        viewModel.delete(at: 0)
        let deleted = try awaitResult(from: deletedItemPublisher)
        XCTAssertNil(deleted.children?.first)
    }
}


