//
//  MockURLProtocol.swift
//  ReaddleAssignmentTests
//
//  Created by Ahmed Mgua on 19/06/2022.
//

import Combine
import Foundation
@testable import ReaddleAssignment
import XCTest

class MockURLProtocol: URLProtocol {
    /// Mocks a URL Response using data provided.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    /// Stores data under URLs so they can be returned as network responses
    static var testURLs = [URL?: Data]()
    
    
    /// URLProtocol conformance
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}
