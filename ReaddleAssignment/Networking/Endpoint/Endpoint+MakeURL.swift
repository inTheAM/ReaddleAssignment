//
//  Endpoint+MakeURL.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

extension Endpoint {
    static let baseURL: String = "sheets.googleapis.com"
    
    /// Creates a `URL` from the parameters of an endpoint.
    /// Throws a `URLError.badURL` error if the url could not be created.
    /// - Returns: A URL.
    func makeURL() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Self.baseURL
        if path.hasPrefix("/") {
            components.path = path
        } else {
            components.path = "/" + path
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
}
