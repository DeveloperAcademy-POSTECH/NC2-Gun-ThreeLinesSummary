//
//  ErrorResponseBody.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/31.
//

import Foundation

struct ErrorResponseBody: Decodable {
    let error: Error
    
    struct Error: Decodable {
        let errorCode: String
        let message: String
    }
}
