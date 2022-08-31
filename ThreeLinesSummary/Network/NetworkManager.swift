//
//  NetworkManager.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/31.
//

import Foundation

struct NetworkManager {
    let urlSession: URLSessionProtocol
    let translationURL = URL(string: "www.naver.com")!
    
    func translate(_ text: String) async throws -> String {
        if text.isEmpty {
            throw NetworkError.emptyText
        }
        
        guard var urlRequest = TranslateAPIAuth.urlRequest else {
            throw NetworkError.unknown
        }
        
        guard let body = getBody(with: text) else {
            throw NetworkError.unknown
        }
        
        urlRequest.httpBody = body
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        if let responseBody = try? JSONDecoder().decode(TranslateResponseBody.self, from: data) {
            return responseBody.message.result.translatedText
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        if response.statusCode >= 500 {
            throw NetworkError.serverError
        }
        
        guard let errorResponseBody = try? JSONDecoder().decode(ErrorResponseBody.self, from: data) else {
            throw NetworkError.unknown
        }
        
        switch errorResponseBody.error.errorCode {
        case "430", "N2MT08":
            throw NetworkError.longText
        case "N2MT07":
            throw NetworkError.emptyText
        default:
            throw NetworkError.unknown
        }
    }
    
    private func getBody(with text: String) -> Data? {
        let body = TranslateRequestBody(text: text)
        
        return try? JSONEncoder().encode(body)
    }
    
    func summarize(_ text: String) async throws -> String {
        let urlRequest = URLRequest(url: URL(string: "www.naver.com")!)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        if let responseBody = try? JSONDecoder().decode(SummaryResponseBody.self, from: data) {
            return responseBody.document.content
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        if response.statusCode >= 500 {
            throw NetworkError.serverError
        }
        
        throw NetworkError.unknown
    }
}
