//
//  PasteView.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/29.
//

import UIKit

class PasteView: PhaseTemplateView {
    let translateButton = UIButton.getSystemButton(title: "번역하기", configuration: .filled())
    let cameraButton = UIButton.getSystemButton(title: "카메라 앱 실행", configuration: .tinted())
    
    init() {
        super.init(title: "영어 텍스트 붙여넣기", instruction: "카메라의 live text 기능을 이용하여 영어 텍스트를 복사, 붙여넣기 하고 오타를 수정하세요.", textCopiable: false)
        addButtons()
    }
    
    private func addButtons() {
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 10
        
        [translateButton, cameraButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 50) / 2).isActive = true
            buttonsStack.addArrangedSubview(button)
        }
        
        stack.addArrangedSubview(buttonsStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
