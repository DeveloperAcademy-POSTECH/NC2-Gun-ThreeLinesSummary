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
    private let subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
