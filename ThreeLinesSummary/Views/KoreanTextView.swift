//
//  TranslateView.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/30.
//

import UIKit
import Combine

class KoreanTextView: PhaseTemplateView {
    let summarizeButton = UIButton.getSystemButton(title: "요약하기", configuration: .filled())
    let goBackButton = UIButton.getSystemButton(title: "처음 단계로", configuration: .tinted())
    let textScanButton = UIButton.getSystemButton(title: "텍스트 스캔하기", configuration: .tinted())
    private var subscriptions = Set<AnyCancellable>()
    let isFirstView: Bool
    
    init(isFirstView: Bool = false) {
        let instruction = isFirstView ? "한국어 텍스트를 복사, 붙여넣기 하세요." : "번역 결과를 확인하고 요약하기를 누르세요."
        self.isFirstView = isFirstView
        super.init(instruction: instruction, textCopiable: !isFirstView)
        addButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButtons() {
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 10
        
        [isFirstView ? textScanButton : goBackButton, summarizeButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 50) / 2).isActive = true
            buttonsStack.addArrangedSubview(button)
        }
        
        stack.addArrangedSubview(buttonsStack)
    }
}
