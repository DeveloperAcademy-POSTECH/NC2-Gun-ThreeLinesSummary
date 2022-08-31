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
    
    func whenTranslateThrowsNetworkError(expectedError: NetworkError) {
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
    
    func whenSummarizeThrowsNetworkError(expectedError: NetworkError) {
        Task {
            do {
                // when
                let _ = try await sut.summarize("dummy text")
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
            do {
                // when
                let text = try await sut.translate("dummy Text")
                
                // then
                XCTAssertEqual(text, expectedText)
                expectation.fulfill()
            } catch {}
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testTranslate_WhenStatusCodeIsAtLeast500_throwsServerError() {
        givenSutAndExpectation(statusCode: 500, fileName: "Translate_Bad_500_900")
        
        whenTranslateThrowsNetworkError(expectedError: .serverError)
    }
    
    func testTranslate_WhenNotDecodableResponseBody_throwsUnknown() {
        givenSutAndExpectation(statusCode: 400, fileName: "Translate_Bad_NotDecodable")
        
        whenTranslateThrowsNetworkError(expectedError: .unknown)
    }
    
    func testTranslate_WhenErrorCodeIs430_throwsLongText() {
        givenSutAndExpectation(statusCode: 413, fileName: "Translate_Bad_413_430")
        
        whenTranslateThrowsNetworkError(expectedError: .longText)
    }
    
    func testTranslate_WhenErrorCodeIsN2MT08_throwsLongText() {
        givenSutAndExpectation(statusCode: 400, fileName: "Translate_Bad_400_N2MT08")
        
        whenTranslateThrowsNetworkError(expectedError: .longText)
    }
    
    func testSummarize_whenResponseIsGood_returnsText() {
        givenSutAndExpectation(statusCode: 200, fileName: "Summary_Good")
        
        let data = try! Data.fromJSON(fileName: "Summary_Good")
        let responseBody = try! JSONDecoder().decode(SummaryResponseBody.self, from: data)
        let expectedText = responseBody.document.content
        
        Task {
            do {
                // when
                let text = try await sut.summarize("dummy Text")
                
                // then
                XCTAssertEqual(text, expectedText)
                expectation.fulfill()
            } catch {}
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSummarize_whenStatusCodeIsAtLeast500_throwsServerError() {
        givenSutAndExpectation(statusCode: 500, fileName: "Summary_Bad_500")
        
        whenSummarizeThrowsNetworkError(expectedError: .serverError)
    }
    
    func testSummarize_whenErrorCodeIsE001_throwsEmptyText() {
        givenSutAndExpectation(statusCode: 400, fileName: "Summary_Bad_400_E001")
        
        whenSummarizeThrowsNetworkError(expectedError: .emptyText)
    }
}
