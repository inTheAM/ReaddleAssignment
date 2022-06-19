//
//  XCTestCase+TestData.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 19/06/2022.
//

import XCTest

extension XCTestCase {
    func setUpTestData(_ url: URL) throws {
        MockURLProtocol.requestHandler = { request in
            guard let data = MockURLProtocol.testURLs[url]
            else {
                throw URLError(.fileDoesNotExist)
            }
            return (HTTPURLResponse(), data)
        }
    }
}
