//
//  TranslateView.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/30.
//

import UIKit
import Combine

class TranslateView: PhaseTemplateView {
    let summarizeButton = UIButton.getSystemButton(title: "예", configuration: .filled())
    let goBackButton = UIButton.getSystemButton(title: "아니오(처음 단계로)", configuration: .tinted())
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        super.init(title: "번역 완료", instruction: "번역이 완료되었습니다.\n요약하시겠습니까?", textCopiable: true)
        addButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButtons() {
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 10
        
        [goBackButton, summarizeButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 50) / 2).isActive = true
            buttonsStack.addArrangedSubview(button)
        }
        
        stack.addArrangedSubview(buttonsStack)
    }
}
