//
//  SummaryViewModel.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/12/25.
//

import Foundation
import Combine

class SummaryTabViewModel {
    @Published private(set) var currentPhase: Phase = .pasted
    @Published private(set) var pastedText = ""
    @Published private(set) var summaryResult = ""
    @Published private(set) var errorMessage = ""
    private let networkManager = NetworkManager(urlSession: URLSession.shared)
    
    func summarize() {
        currentPhase = .summarizing
        
        Task {
            do {
                let result = try await networkManager.summarize(pastedText)
                currentPhase = .finished
                summaryResult = result
            } catch {
                self.currentPhase = .failed
                let errorMessage = ((error as? NetworkError) ?? .unknown).message
                self.errorMessage = errorMessage
            }
        }
    }
    
    func goBack() {
        currentPhase = .pasted
    }
    
    func goToStart() {
        currentPhase = .pasted
    }
    
    func bindPastedText(to publisher: AnyPublisher<String, Never>) {
        publisher.assign(to: &$pastedText)
    }
    
    func bindSummaryText(to publisher: AnyPublisher<String, Never>) {
        publisher.assign(to: &$summaryResult)
    }
}

extension SummaryTabViewModel {
    enum Phase {
        case pasted
        case summarizing
        case failed
        case finished
        
        var navigationTitle: String {
            switch self {
            case .pasted:
                return "한글 텍스트 붙여넣기"
            case .summarizing:
                return "요약 중"
            case .failed:
                return "요약 실패"
            case .finished:
                return "요약 완료"
            }
        }
    }
}
