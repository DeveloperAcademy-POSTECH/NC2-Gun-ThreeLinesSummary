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
        let (data, response) = try await urlSession.data(for: URLRequest(url: translationURL))
        
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
        
        
        
        return ""
    }
}
