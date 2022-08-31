//
//  TranslateRequestBody.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/31.
//

import Foundation

struct TranslateRequestBody: Encodable {
    let source = "en"
    let target = "ko"
    let text: String
}
