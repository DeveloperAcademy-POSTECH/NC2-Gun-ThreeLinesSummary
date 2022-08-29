//
//  BorderedTextField.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/29.
//

import UIKit

class BorderedTextField: UIView {
    var text: String {
        get {
            textField.text
        }
        
        set {
            textField.text = newValue
        }
    }
    
    private let textField: UITextView = {
        let textField = UITextView()
        textField.isEditable = true
        textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        return textField
    }()
    
    init(height: CGFloat, isCopiable: Bool = false) {
        super.init(frame: .zero)
        
        addBorder()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        addTextField()
        
        if isCopiable {
            addCopyButton()
        }
    }
    
    private func addBorder() {
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    private func addTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    private func addCopyButton() {
        let button = CustomButton()
        button.setImage(UIImage(systemName: "square.on.square"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(copyText), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 36),
            button.heightAnchor.constraint(equalToConstant: 36),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func copyText() {
        UIPasteboard.general.string = textField.text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
