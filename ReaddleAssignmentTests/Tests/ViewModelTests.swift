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


}


