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
        
        guard var urlRequest = TranslateAPI.urlRequest else {
            throw NetworkError.unknown
        }
        
        guard let body = getTranslateRequestBody(with: text) else {
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
    
    private func getTranslateRequestBody(with text: String) -> Data? {
        let body = TranslateRequestBody(text: text)
        
        return try? JSONEncoder().encode(body)
    }
    
    func summarize(_ text: String) async throws -> String {
        guard var urlRequest = SummaryAPI.urlRequest else {
            throw NetworkError.unknown
        }
        
        guard let body = getSummaryRequestBody(with: text) else {
            throw NetworkError.unknown
        }
        
        urlRequest.httpBody = body
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        if let responseBody = try? JSONDecoder().decode(SummaryResponseBody.self, from: data) {
            return responseBody.summary
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
        case "E001":
            throw NetworkError.emptyText
        case "E002":
            throw NetworkError.encoding
        case "E003":
            throw NetworkError.longText
        case "E100":
            throw NetworkError.invalidText
        default:
            throw NetworkError.unknown
        }
    }
    
    private func getSummaryRequestBody(with text: String) -> Data? {
        let body = SummaryRequestBody(content: text)
        
        return try? JSONEncoder().encode(body)
    }
}
