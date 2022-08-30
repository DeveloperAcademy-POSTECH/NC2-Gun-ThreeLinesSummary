//
//  ErrorView.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/30.
//

import UIKit

class ErrorView: UIView {
    private let errorImageView = UIImageView.ofSystemImage(systemName: "x.circle", fontSize: 80, weight: .regular, color: .red)
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }()
    
    private let goBackButton = UIButton.getSystemButton(title: "이전 단계로", configuration: .filled())
    private let goToStartButton = UIButton.getSystemButton(title: "처음 단계로", configuration: .tinted())
    
    var message: String {
        get {
            errorMessageLabel.text ?? ""
        }
        
        set {
            errorMessageLabel.text = newValue
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 25
        vStack.alignment = .center
        
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 10
        
        [goBackButton, goToStartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 50) / 2).isActive = true
            buttonsStack.addArrangedSubview($0)
        }
        
        [errorImageView, errorMessageLabel, buttonsStack].forEach {
            vStack.addArrangedSubview($0)
        }
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
