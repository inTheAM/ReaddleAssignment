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
        viewModel = ViewModel(file: .rootDirectory, service: MockGoogleSheetsService())
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


extension XCTestCase {
    /// Awaits the result of a publisher and returns the output or throws an error.
    /// - Parameters:
    ///   - publisher: The publisher to subscribe to for results.
    ///   - timeout: The time to wait for a result, after which
    ///              an error is thrown if the publisher did not output.
    ///   - file: The file in which the method was called when an error is thrown.
    ///   - line: The line in which the method was called when an error is thrown.
    /// - Returns: The output of the publisher.
    func awaitResult<T: Publisher>(
        from publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")
        
        let cancellable = publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }
                expectation.fulfill()
            },
                  receiveValue: { value in
                result = .success(value)
            }
            )
        waitForExpectations(timeout: timeout)
        cancellable.cancel()
        
        let unwrappedResult = try XCTUnwrap(result,
                                            "Awaited publisher did not produce any output",
                                            file: file,
                                            line: line)
        
        return try unwrappedResult.get()
    }
}
