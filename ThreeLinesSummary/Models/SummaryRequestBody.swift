//
//  SummaryRequestBody.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/31.
//

import Foundation

struct SummaryRequestBody: Encodable {
    let document: Document
    let option = Option()
    
    init(content: String) {
        self.document = Document(content: content)
    }
    
    struct Document: Encodable {
        let content: String
    }
    
    struct Option: Encodable {
        let language = "ko"
        let model = "general"
        let tone = 0
        let summaryCount = 3
    }
}
