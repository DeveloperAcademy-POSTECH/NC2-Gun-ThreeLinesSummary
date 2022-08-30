//
//  LoadingView.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/30.
//

import UIKit

class LoadingView: UIView {
    let loadingMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .gray
        
        return activityView
    }()
    
    init(message: String) {
        loadingMessageLabel.text = message
        super.init(frame: .zero)
        
        [loadingMessageLabel, activityIndicator].forEach { [unowned self] view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loadingMessageLabel.bottomAnchor.constraint(equalTo: activityIndicator.topAnchor, constant: -36),
            loadingMessageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
