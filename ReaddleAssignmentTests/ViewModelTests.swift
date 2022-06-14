//
//  ViewModelTests.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import XCTest
@testable import ReaddleAssignment

class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    override func setUpWithError() throws {
        viewModel = ViewModel(service: MockGoogleSheetsService())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchingSpreadsheet() throws {
        let expectation = expectation(description: "files fetched successfully")
        viewModel.fetchSpreadsheet {
            XCTAssertEqual(self.viewModel.file.children?[0].id, FileItem.samples[0].id)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }


}
