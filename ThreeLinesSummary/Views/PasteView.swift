//
//  PasteView.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/29.
//

import UIKit
import Combine

class PasteView: PhaseTemplateView {
    let translateButton = UIButton.getSystemButton(title: "번역하기", configuration: .filled())
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        super.init(title: "영어 텍스트 붙여넣기", instruction: "카메라의 live text 기능을 이용하여 영어 텍스트를 복사, 붙여넣기 하고 오타를 수정하세요.", textCopiable: false)
        addButtons()
    }
    
    private func addButtons() {
        stack.addArrangedSubview(translateButton)
        
        textField.textPublisher
            .sink { [unowned self] text in
                translateButton.decideActivation(with: text)
            }
            .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
