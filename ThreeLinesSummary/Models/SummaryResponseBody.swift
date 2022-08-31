//
//  SummaryResponseBody.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/31.
//

import Foundation

struct SummaryResponseBody: Decodable {
    let document: Document
    
    struct Document: Decodable {
        let content: String
    }
}
