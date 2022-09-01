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
            .map { [unowned self] phase -> UIView in
                switch phase {
                case .pasted:
                    return pasteView
                case .finishedTranslate:
                    return translateView
                case .finishedSummarize:
                    return summaryView
                case .translating, .summarizing:
                    return loadingView
                case .failedTranslate, .failedSummarize:
                    return errorView
                }
            }
            .sink { [unowned self] view in
                self.view = view
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
    }


}

