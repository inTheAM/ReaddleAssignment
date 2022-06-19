//
//  NetworkManager.swift
//  ReaddleAssignment
//
//  Created by Ahmed Mgua on 08/06/2022.
//

import Combine
import Foundation

/// The main network manager for performing network calls.
struct NetworkManager {
    private let authService: AuthServiceProtocol = AuthService()
    /// The URLSession instance to use in the requests.
    internal let urlSession: URLSession
    
    internal init(session: URLSession = .shared) {
        self.urlSession = session
    }
    
    /// Creates a `URLRequest` from the given endpoint.
    /// - Parameters:
    ///   - endpoint: The endpoint for the resource required
    /// - Returns: A URLRequest.
    private func makeURLRequest(for endpoint: Endpoint) throws -> URLRequest {
        let url = try endpoint.makeURL()
        var request = URLRequest(url: url)
        request.httpMethod  =   endpoint.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        return request
    }
    
    /// Attaches a payload to a URLRequest.
    /// - Parameters:
    ///   - payload: The data to attach to the body of the request.
    ///   - request: The request to attach the payload to.
    private func attach<Payload>(_ payload: Payload, to request: inout URLRequest) throws
    where Payload: Encodable {
        let body = try JSONEncoder().encode(payload)
        request.httpBody = body
    }
    
    /// Adds authorization headers to a request.
    /// - Parameters:
    ///   - request: The request to authorize.
    ///   - token: The token to attach.
    private func authorize(_ request: inout URLRequest, with token: String) {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
    }
}

extension NetworkManager: NetworkManagerProtocol {
    
    func performRequest<Response>(
        endpoint: Endpoint,
        requiresAuthorization: Bool = false,
        responseType: Response.Type?) -> AnyPublisher<Response, Error>
    where Response: Decodable {
        do {
            var request = try makeURLRequest(for: endpoint)
            let decoder = JSONDecoder()
            
            return authService.tokenPublisher()
                .flatMap { token -> URLSession.DataTaskPublisher in
                    if requiresAuthorization, let token = token {
                        authorize(&request, with: token)
                    }
                    
                    // dataTaskPublisher(for:_) by default runs on a background thread.
                    return urlSession.dataTaskPublisher(for: request)
                }
#if DEBUG
                .map { output in
                    let object = try? JSONSerialization.jsonObject(with: output.data)
                    let data = try? JSONSerialization.data(withJSONObject: object!, options: [.prettyPrinted])
                    let prettyPrintedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("\n==========DATA==========\n", prettyPrintedString as Any, "\n\n")
                    return output.data
                }
#else
                .map(\.data)
#endif
                .decode(type: Response.self, decoder: decoder)
                .mapError({ error in
                    dump(error, name: "ERROR LOADING DATA: ")
                    return error
                })
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Request with payload
    /// Performs a request using the given endpoint, authorization type, and payload.
    /// - Parameters:
    ///   - endpoint: The endpoint for the resource being requested.
    ///   - payload: The data being sent in the request.
    /// - Returns: A publisher that publishes either the decoded response from the server or a request error.
    func performRequest<Payload, Response>(
        endpoint: Endpoint,
        requiresAuthorization: Bool = true,
        payload: Payload) -> AnyPublisher<Response, Error>
    where Payload: Encodable, Response: Decodable {
        do {
            var request = try makeURLRequest(for: endpoint)
            try attach(payload, to: &request)
            dump(request)
            let decoder = JSONDecoder()
            return authService.tokenPublisher()
                .flatMap { token -> URLSession.DataTaskPublisher in
                    if requiresAuthorization, let token = token {
                        authorize(&request, with: token)
                    }
                    return urlSession.dataTaskPublisher(for: request)
                }
#if DEBUG
                .map { output in
                    let object = try? JSONSerialization.jsonObject(with: output.data)
                    let data = try? JSONSerialization.data(withJSONObject: object!, options: [.prettyPrinted])
                    let prettyPrintedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("\n==========DATA==========\n", prettyPrintedString as Any, "\n\n")
                    return output.data
                }
#else
                .map(\.data)
#endif
                .decode(type: Response.self, decoder: decoder)
                .mapError { error in
                    dump(error, name: "ERROR LOADING DATA: ")
                    return error
                }
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}



