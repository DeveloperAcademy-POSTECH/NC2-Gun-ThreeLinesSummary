//
//  Data.swift
//  ThreeLinesSummaryTests
//
//  Created by 김남건 on 2022/08/30.
//

import Foundation
import XCTest

extension Data {
    public static func fromJSON(fileName: String,
                                file: StaticString = #file,
                                line: UInt = #line) throws -> Data {
        
        let bundle = Bundle(for: TestBundleClass.self)
        let url = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: "json"),
                                "Unable to find \(fileName).json. Did you add it to the tests?",
                                file: file, line: line)
        return try Data(contentsOf: url)
    }
}

private class TestBundleClass { }

// https://www.raywenderlich.com/books/ios-test-driven-development-by-tutorials/v2.0/chapters/8-restful-networking
