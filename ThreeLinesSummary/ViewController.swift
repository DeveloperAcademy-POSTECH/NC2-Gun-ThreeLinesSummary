//
//  ViewController.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/26.
//

import UIKit
import Combine

class ViewController: UIViewController {
    let pasteView = PasteView()
    let translateView = TranslateView()
    let summaryView = SummaryView()
    let loadingView = LoadingView()
    let errorView = ErrorView()
    
    private var viewModel = ViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                self.title = phase.navigationTitle
            }
            .store(in: &subscriptions)
        
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
        
        viewModel.$loadingMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.message, on: loadingView)
            .store(in: &subscriptions)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.message, on: errorView)
            .store(in: &subscriptions)
        
        viewModel.bindPastedText(to: pasteView.textField.textPublisher)
        viewModel.bindTranslateText(to: translateView.textField.textPublisher)
        viewModel.bindSummaryText(to: summaryView.textField.textPublisher)
        
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

