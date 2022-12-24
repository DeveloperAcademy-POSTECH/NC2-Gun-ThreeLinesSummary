//
//  PhaseTemplateView.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/29.
//

import UIKit

class PhaseTemplateView: UIView {
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    let textField: BorderedTextField
    
    var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        
        return stack
    }()
    
    let navigationBarTitle: String
    
    init(title: String, instruction: String, textCopiable: Bool) {
        self.navigationBarTitle = title
        self.textField = BorderedTextField(height: UIScreen.main.bounds.height - 351, isCopiable: textCopiable)
        super.init(frame: .zero)
        
        instructionLabel.text = instruction
        
        setLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setLayout() {
        stack.addArrangedSubview(instructionLabel)
        stack.addArrangedSubview(textField)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func hideKeyboard() {
        self.endEditing(true)
    }
}
