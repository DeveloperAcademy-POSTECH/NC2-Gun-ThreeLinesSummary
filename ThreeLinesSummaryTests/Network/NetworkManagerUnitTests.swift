//
//  NetworkManagerTests.swift
//  ThreeLinesSummaryTests
//
//  Created by 김남건 on 2022/08/31.
//

import XCTest
@testable import ThreeLinesSummary

class NetworkManagerUnitTests: XCTestCase {
    var sut: NetworkManager!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        expectation = nil
        try super.tearDownWithError()
    }
    
    func givenSutAndExpectation(statusCode: Int, fileName: String) {
        sut = NetworkManager(urlSession: FakeURLSession(statusCode: statusCode, fileName: fileName))
        expectation = expectation(description: "Task should be executed during test.")
    }
    
    func whenThrowsNetworkError(expectedError: NetworkError) {
        Task {
            do {
                // when
                let _ = try await sut.translate("dummy text")
            } catch {
                // then
                XCTAssertTrue(error is NetworkError)
                XCTAssertEqual(error as! NetworkError, expectedError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testTranslate_whenTextIsEmpty_throwsEmptyText() {
        givenSutAndExpectation(statusCode: 200, fileName: "Translate_Good")
        
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

    func testTranslate_WhenResponseIsGood_returnsText() {
        // given
        givenSutAndExpectation(statusCode: 200, fileName: "Translate_Good")
        
        let data = try! Data.fromJSON(fileName: "Translate_Good")
        let responseBody = try! JSONDecoder().decode(TranslateResponseBody.self, from: data)
        let expectedText = responseBody.message.result.translatedText
        
        Task {
            // when
            let text = try! await sut.translate("dummy Text")
            
            // then
            XCTAssertEqual(text, expectedText)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testTranslate_WhenStatusCodeIsAtLeast500_throwsServerError() {
        givenSutAndExpectation(statusCode: 500, fileName: "Translate_Bad_500_900")
        
        whenThrowsNetworkError(expectedError: .serverError)
    }
    
    func testTranslate_WhenNotDecodableResponseBody_throwsUnknown() {
        givenSutAndExpectation(statusCode: 400, fileName: "Translate_Bad_NotDecodable")
        
        whenThrowsNetworkError(expectedError: .unknown)
    }
    
    func testTranslate_WhenErrorCodeIs430_throwsLongText() {
        givenSutAndExpectation(statusCode: 413, fileName: "Translate_Bad_413_430")
        
        whenThrowsNetworkError(expectedError: .longText)
    }
    
    func testTranslate_WhenErrorCodeIsN2MT08_throwsLongText() {
        givenSutAndExpectation(statusCode: 400, fileName: "Translate_Bad_400_N2MT08")
        
        whenThrowsNetworkError(expectedError: .longText)
    }
}
