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
}

extension NetworkManager: NetworkManagerProtocol {
    
    func performRequest<Response>(
        endpoint: Endpoint,
        responseType: Response.Type?) -> AnyPublisher<Response, Error>
    where Response: Decodable {
        do {
            let request = try makeURLRequest(for: endpoint)
            
            let decoder = JSONDecoder()
            return urlSession.dataTaskPublisher(for: request)
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
    
}



