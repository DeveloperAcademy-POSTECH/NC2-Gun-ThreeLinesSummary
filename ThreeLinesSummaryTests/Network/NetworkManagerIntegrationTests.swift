//
//  NetworkManagerIntegrationTests.swift
//  ThreeLinesSummaryTests
//
//  Created by 김남건 on 2022/08/31.
//

import XCTest
@testable import ThreeLinesSummary

class NetworkManagerIntegrationTests: XCTestCase {
    var sut: NetworkManager!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager(urlSession: URLSession.shared)
        expectation = expectation(description: "Task should be executed during test.")
    }

    override func tearDownWithError() throws {
        sut = nil
        expectation = nil
        try super.tearDownWithError()
    }

    func testTranslate() {
        Task {
            do {
                let text = try await sut.translate("I believe I can fly.")
                XCTAssertEqual(text, "난 내가 날 수 있다고 믿어요.")
                expectation.fulfill()
            } catch {
                
            }
            
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testTranslate_whenTextIsEmpty_throwsEmptyText() {
        Task {
            do {
                let _ = try await sut.translate("")
            } catch {
                XCTAssertTrue(error is NetworkError)
                XCTAssertEqual(error as? NetworkError, NetworkError.emptyText)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }
}
