//
//  ViewModel.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/09/01.
//

import Foundation

enum Phase {
    case pasted
    case translating
    case finishedTranslate
    case failedTranslate
    case summarizing
    case finishedSummarize
    case failedSummarize
    
    var navigationTitle: String {
        switch self {
        case .pasted:
            return "영어 텍스트 복사, 붙여넣기"
        case .translating:
            return "번역 중"
        case .finishedTranslate:
            return "번역 완료"
        case .failedTranslate:
            return "번역 실패"
        case .summarizing:
            return "요약 중"
        case .finishedSummarize:
            return "요약 완료"
        case .failedSummarize:
            return "요약 실패"
        }
    }
}

class ViewModel: ObservableObject {
    @Published private(set) var currentPhase: Phase = .pasted
    @Published private(set) var pastedText = ""
    @Published private(set) var translateResult = ""
    @Published private(set) var summaryResult = ""
    @Published private(set) var loadingMessage = ""
    @Published private(set) var errorMessage = ""
    private var networkManager = NetworkManager(urlSession: URLSession.shared)
    
    func translate(_ text: String) {
        currentPhase = .translating
        loadingMessage = "번역 중..."
        
        Task {
            do {
                let result = try await networkManager.translate(text)
                currentPhase = .finishedTranslate
                translateResult = result
            } catch {
                self.currentPhase = .failedTranslate
                let errorMessage = ((error as? NetworkError) ?? .unknown).message
                self.errorMessage = errorMessage
            }
        }
    }
}