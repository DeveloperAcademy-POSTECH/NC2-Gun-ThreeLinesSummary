//
//  FakeURLSession.swift
//  ThreeLinesSummaryTests
//
//  Created by 김남건 on 2022/08/30.
//

import Foundation
@testable import ThreeLinesSummary

class FakeURLSession: URLSessionProtocol {
    let statusCode: Int
    let data: Data
    
    init(statusCode: Int, fileName: String) {
        self.statusCode = statusCode
        self.data = try! Data.fromJSON(fileName: fileName)
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return (data, HTTPURLResponse(url: URL(string: "www.naver.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!)
    }
}
