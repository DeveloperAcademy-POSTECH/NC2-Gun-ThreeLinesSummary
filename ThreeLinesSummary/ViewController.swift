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
            .sink { [unowned self] text in
                pasteView.textField.text = text
            }
            .store(in: &subscriptions)
        
        viewModel.$translateResult
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] result in
                translateView.textField.text = result
            }
            .store(in: &subscriptions)
        
        viewModel.$summaryResult
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] result in
                summaryView.textField.text = result
            }
            .store(in: &subscriptions)
        
        viewModel.$loadingMessage
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] message in
                loadingView.message = message
            }
            .store(in: &subscriptions)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] message in
                errorView.message = message
            }
            .store(in: &subscriptions)
        
        pasteView.translateButton.addTarget(self, action: #selector(translateButtonClicked), for: .touchUpInside)
        translateView.summarizeButton.addTarget(self, action: #selector(summarize), for: .touchUpInside)
        
        translateView.goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        errorView.goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        errorView.goToStartButton.addTarget(self, action: #selector(goToStart), for: .touchUpInside)
        summaryView.goToStartButton.addTarget(self, action: #selector(goToStart), for: .touchUpInside)
    }

    @objc private func translateButtonClicked() {
        viewModel.translate(pasteView.textField.text)
    }
    
    @objc private func goBack() {
        viewModel.goBack()
    }
    
    @objc private func summarize() {
        viewModel.summarize(translateView.textField.text)
    }
    
    @objc private func goToStart() {
        viewModel.goToStart()
    }
}

