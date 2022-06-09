//
//  NetworkManagerProtocol.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Combine
import Foundation

protocol NetworkManagerProtocol {
    
    /// Performs the request returning the response from a url request or a `URLError`.
    /// - Parameters:
    ///   - endpoint: The api endpoint for the resource being requested.
    ///   - response: The type of response expected.
    /// - Returns: A publisher that publishes the response of the request on success
    ///            or a `RequestError` in case of failure.
    func performRequest<Response>(
        endpoint: Endpoint,
        responseType: Response.Type?) -> AnyPublisher<Response, Error>
    where Response: Decodable
}
