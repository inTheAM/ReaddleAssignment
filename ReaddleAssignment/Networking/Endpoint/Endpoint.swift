//
//  Endpoint.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 09/06/2022.
//

import Foundation

struct Endpoint {
    
    /// The http method associated with the endpoint.
    let httpMethod: HTTPMethod
    
    /// The path to the resource.
    let path: String
    
    /// The query items to add to the endpoint when constructing the url.
    let queryItems: [URLQueryItem]
    
    init(httpMethod: HTTPMethod, path: String, queryItems: [URLQueryItem] = []) {
        self.httpMethod = httpMethod
        self.path = path
        let apiKey = URLQueryItem(name: "key", value: "AIzaSyC9-x2_tQ7mV8PpHOlgweE0Y0di1gpMeY4")
        self.queryItems = [apiKey] + queryItems
    }
    
    enum HTTPMethod: String {
        case get = "GET",
             post = "POST"
    }
}
