//
//  SummaryViewController.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/12/25.
//

import UIKit
import Combine

class SummaryTabViewController: UIViewController {
    private let koreanTextView = KoreanTextView(isFirstView: true)
    private let summaryView = SummaryView()
    private let errorView = ErrorView()
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.message = "요약 중..."
        
        return loadingView
    }()
    
    private let viewModel = SummaryTabViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindPhaseToViews()
        bindTextFieldToPublished()
    }
}

// MARK: - Binding
extension SummaryTabViewController {
    private func bindPhaseToViews() {
        viewModel.$currentPhase
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] phase in
                switch phase {
                case .pasted:
                    self.view = koreanTextView
                case .summarizing:
                    self.view = loadingView
                case .finished:
                    self.view = summaryView
                case .failed:
                    self.view = errorView
                }
                
                navigationItem.title = phase.navigationTitle
            }
            .store(in: &subscriptions)
    }
    
    private func bindTextFieldToPublished() {
        viewModel.$pastedText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: koreanTextView.textField)
            .store(in: &subscriptions)
        
        viewModel.$summaryResult
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: summaryView.textField)
            .store(in: &subscriptions)
        
        viewModel.bindPastedText(to: koreanTextView.textField.textPublisher)
        viewModel.bindSummaryText(to: summaryView.textField.textPublisher)
    }
}
