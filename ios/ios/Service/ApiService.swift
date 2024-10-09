//
//  ApiService.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation

enum Method: String {
    case GET, POST, PUT, DELETE
}

class ApiService{
    private var hostname = "http://localhost:8000/"
    
    init() {}
    
    init(_ hostname: String) {
        self.hostname = hostname
    }
    
    private func checkStatus(_ response : HTTPURLResponse) throws {
        let invalidCodes: Set<Int> = [400, 404, 500]
        
        if invalidCodes.contains(response.statusCode) {
            throw NSError(domain: "Invalid status code", code: response.statusCode, userInfo: nil)
        }
    }
    
    func fetch(path: String, method: Method, data: Data? = nil, authToken: String? = nil) async throws -> Data {
        guard let url = URL(string: self.hostname + path) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if authToken != nil {
            request.setValue("Bearer \(String(describing: authToken))", forHTTPHeaderField: "Authorization")
        }
        
        if let data = data {
            request.httpBody = data
        }

        let (responseData, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: 500, userInfo: nil)
        }
        try checkStatus(httpResponse)
        
        return responseData
    }

}
