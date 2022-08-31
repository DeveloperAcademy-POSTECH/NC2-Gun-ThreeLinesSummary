//
//  NetworkManagerIntegrationTests.swift
//  ThreeLinesSummaryTests
//
//  Created by 김남건 on 2022/08/31.
//

import XCTest
@testable import ThreeLinesSummary

class NetworkManagerIntegrationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTranslate() {
        let sut = NetworkManager(urlSession: URLSession.shared)
        let expectation = expectation(description: "Task should be executed during test.")
        
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
        let sut = NetworkManager(urlSession: URLSession.shared)
        let expectation = expectation(description: "Task should be executed during test.")
        
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
