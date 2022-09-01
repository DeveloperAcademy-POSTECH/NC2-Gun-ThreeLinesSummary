//
//  SummaryView.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/30.
//

import UIKit

class SummaryView: PhaseTemplateView {
    let goToStartButton = UIButton.getSystemButton(title: "처음 단계로", configuration: .filled())
    
    init() {
        super.init(title: "요약 완료", instruction: "요약이 완료되었습니다!", textCopiable: true)
        addButtons()
    }
    
    private func addButtons() {
        stack.addArrangedSubview(goToStartButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
