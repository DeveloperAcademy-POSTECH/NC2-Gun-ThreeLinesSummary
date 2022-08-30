//
//  TranslateDataDecoder.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/31.
//

import Foundation

struct TranslateResponseBody: Decodable {
    let message: Message
    
    struct Message: Decodable {
        let result: Result
        
        struct Result: Decodable {
            let translatedText: String
        }
    }
}
