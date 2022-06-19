//
//  GoogleSheetsServiceTests.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 19/06/2022.
//

import Combine
@testable import ReaddleAssignment
import XCTest

extension SpreadsheetUpdateResponse: Encodable {
    enum CodingKeys: CodingKey {
        case updates
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(updates, forKey: .updates)
    }
    
    
}
extension SpreadsheetUpdateResponse.UpdateData: Encodable {
    enum CodingKeys: CodingKey {
        case updatedRange
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(updatedRange, forKey: .updatedRange)
    }
}

extension SpreadsheetClearResponse: Encodable {
    enum CodingKeys: CodingKey {
        case spreadsheetId, clearedRanges
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(spreadsheetId, forKey: .spreadsheetId)
        try container.encode(clearedRanges, forKey: .clearedRanges)
    }
}

class GoogleSheetsServiceTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var service: GoogleSheetsService!
    var spreadsheetURL: URL!
    var addItemURL: URL!
    var deleteItemURL: URL!
    
    override func setUpWithError() throws {
        // Configuring test data
        
        // Setting mock data urls
        spreadsheetURL = try Endpoint.getSpreadsheet("", range: "A:D").makeURL()
        addItemURL = try Endpoint.addItem("", range: "A:D").makeURL()
        deleteItemURL = try Endpoint.deleteItem("").makeURL()
        
        // Encoding data
        let files = FileItem.samples
        let fetchData = SpreadsheetData(range: "A:D", values: files)
        let addItemData = SpreadsheetUpdateResponse(updates: .init(updatedRange: "A1:D1"))
        let deleteItemData = SpreadsheetClearResponse(spreadsheetId: "", clearedRanges: ["Sheet1!A1:D1"])
        let encoder = JSONEncoder()
        let spreadsheetResponse = try encoder.encode(fetchData)
        let addItemResponse = try encoder.encode(addItemData)
        let deleteItemResponse = try encoder.encode(deleteItemData)
        
        // Setting encoded data to the url
        MockURLProtocol.testURLs[spreadsheetURL] =  spreadsheetResponse
        MockURLProtocol.testURLs[addItemURL] = addItemResponse
        MockURLProtocol.testURLs[deleteItemURL] = deleteItemResponse
        
        // Setting configuration for mock url session
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        // Setting mock network manager to handle requests
        let session = URLSession(configuration: config)
        let mockNetworkManager = NetworkManager(session: session)
        service = GoogleSheetsService(networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        service = nil
        spreadsheetURL = nil
    }
    
    func testFetchingSpreadsheet() throws {
        try setUpTestData(spreadsheetURL)
        
        let expectation = expectation(description: "Request successful")
        
        service.fetchSpreadsheet()
            .catch { error -> AnyPublisher<[FileItem], Never> in
                Just([])
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .sink { files in
                XCTAssertFalse(files.isEmpty)
                XCTAssertEqual(files.count, 2)
                XCTAssertEqual(files[0].id, FileItem.samples[0].id)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
    }
    
    func testAddingItem() throws {
        try setUpTestData(addItemURL)
        let expectation = expectation(description: "Request successful")
        
        service.addItem(.sample)
            .catch { error -> AnyPublisher<FileItem?, Never> in
                Just(nil)
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .sink { item in
                XCTAssertNotNil(item)
                XCTAssertEqual(item?.id, FileItem.sample.id)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5)
    }
    
    func testDeletingItem() throws {
        try setUpTestData(deleteItemURL)
        let expectation = expectation(description: "Request successful")
        
        service.deleteItem(.sample)
            .catch { error -> AnyPublisher<Bool, Never> in
                Just(false)
                    .setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
            }
            .sink { didDelete in
                XCTAssert(didDelete)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 5)
    }
}
