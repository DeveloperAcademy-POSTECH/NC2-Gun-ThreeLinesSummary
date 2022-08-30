//
//  URLSessionProtocol.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/30.
//

import Foundation

protocol URLSessionProtocol: AnyObject {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(for: request, delegate: nil)
    }
}
