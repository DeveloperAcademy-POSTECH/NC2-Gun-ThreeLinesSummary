//
//  NetworkError.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/31.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case unknown
    case longText
    case emptyText
    case encoding
    case invalidText
    
    var message: String {
        switch self {
        case .serverError:
            return "서버에서 에러가 발생했습니다. 다시 시도해보세요."
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        case .longText:
            return "텍스트가 너무 깁니다."
        case .emptyText:
            return "텍스트가 비어 있습니다."
        case .encoding:
            return "인코딩에 문제가 있습니다."
        case .invalidText:
            return "유효하지 않은 텍스트입니다."
        }
    }
}
