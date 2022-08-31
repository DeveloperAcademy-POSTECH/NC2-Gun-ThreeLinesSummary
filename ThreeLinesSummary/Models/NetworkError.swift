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
}
