//
//  ViewController.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/26.
//

import UIKit
import Combine

class TranslateSummaryViewController: UIViewController {
    let pasteView = EnglishTextView()
    let translateView = KoreanTextView()
    let summaryView = SummaryView()
    let loadingView = LoadingView()
    let errorView = ErrorView()
    
    private var viewModel = TranslateSummaryViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Binding
        bindPhaseToViews()
        bindTextFieldTextToPublished()
        bindMessageToErrorLoadingView()
        
        // Button Actions
        addTargetsToButtons()
    }
}

// MARK: - Binding Methods
extension TranslateSummaryViewController {
    private func bindPhaseToViews() {
        viewModel.$currentPhase
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] phase in
                switch phase {
                case .pasted:
                    self.view = pasteView
                case .finishedTranslate:
                    self.view = translateView
                case .finishedSummarize:
                    self.view = summaryView
                case .translating, .summarizing:
                    self.view = loadingView
                case .failedTranslate, .failedSummarize:
                    self.view = errorView
                }
                
                navigationItem.title = phase.navigationTitle
            }
            .store(in: &subscriptions)
        
        navigationItem.title = TranslateSummaryViewModel.Phase.pasted.navigationTitle
    }
    
    private func bindTextFieldTextToPublished() {
        viewModel.$pastedText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: pasteView.textField)
            .store(in: &subscriptions)
        
        viewModel.$translateResult
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: translateView.textField)
            .store(in: &subscriptions)
        
        viewModel.$summaryResult
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: summaryView.textField)
            .store(in: &subscriptions)
        
        viewModel.bindPastedText(to: pasteView.textField.textPublisher)
        viewModel.bindTranslateText(to: translateView.textField.textPublisher)
        viewModel.bindSummaryText(to: summaryView.textField.textPublisher)
    }
    
    private func bindMessageToErrorLoadingView() {
        viewModel.$loadingMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.message, on: loadingView)
            .store(in: &subscriptions)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.message, on: errorView)
            .store(in: &subscriptions)
    }
}

// MARK: - Button Actions
extension TranslateSummaryViewController {
    private func addTargetsToButtons() {
        pasteView.textScanButton.addTarget(self, action: #selector(captureTextFromCamera), for: .touchUpInside)
        pasteView.translateButton.addTarget(self, action: #selector(translateButtonClicked), for: .touchUpInside)
        translateView.summarizeButton.addTarget(self, action: #selector(summarize), for: .touchUpInside)
        
        [translateView.goBackButton, errorView.goBackButton].forEach { [unowned self] button in
            button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        [errorView.goToStartButton, summaryView.goToStartButton].forEach { [unowned self] button in
            button.addTarget(self, action: #selector(goToStart), for: .touchUpInside)
        }
    }
    
    @objc private func translateButtonClicked() {
        viewModel.translate()
    }
    
    @objc private func goBack() {
        viewModel.goBack()
    }
    
    @objc private func summarize() {
        viewModel.summarize()
    }
    
    @objc private func goToStart() {
        viewModel.goToStart()
    }
}

extension TranslateSummaryViewController: UIKeyInput {
    var hasText: Bool {
        false
    }
    
    func deleteBackward() {
        pasteView.textField.text = ""
    }
    
    func insertText(_ text: String) {
        pasteView.textField.text = text
    }
}
