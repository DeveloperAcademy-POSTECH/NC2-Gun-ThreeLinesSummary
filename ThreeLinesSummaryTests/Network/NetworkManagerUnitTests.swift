//
//  NetworkManagerTests.swift
//  ThreeLinesSummaryTests
//
//  Created by 김남건 on 2022/08/31.
//

import XCTest
@testable import ThreeLinesSummary

class NetworkManagerUnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTranslate_WhenResponseIsGood_returnsText() {
        // given
        let sut = NetworkManager(urlSession: FakeURLSession(statusCode: 200, fileName: "Translate_Good"))
        
        let data = try! Data.fromJSON(fileName: "Translate_Good")
        let responseBody = try! JSONDecoder().decode(TranslateResponseBody.self, from: data)
        let expectedText = responseBody.message.result.translatedText
        let expectation = expectation(description: "Task should be executed during test.")
        
        Task {
            // when
            let text = try! await sut.translate("")
            
            // then
            XCTAssertEqual(text, expectedText)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testTranslate_WhenStatusCodeIsAtLeast500_throwsServerError() {
        let sut = NetworkManager(urlSession: FakeURLSession(statusCode: 500, fileName: "Translate_Bad_500_900"))
        let expectation = expectation(description: "Task should be executed during test.")
        
        Task {
            do {
                let _ = try await sut.translate("")
            } catch {
                XCTAssertTrue(error is NetworkError)
                XCTAssertEqual(error as! NetworkError, NetworkError.serverError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}