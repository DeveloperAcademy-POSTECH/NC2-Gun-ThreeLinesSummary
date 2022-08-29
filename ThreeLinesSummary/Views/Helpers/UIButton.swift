//
//  UIButton.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/08/29.
//

import UIKit

extension UIButton {
    static func getSystemButton(title: String, configuration: UIButton.Configuration, fontSize: CGFloat = 17, fontWeight: UIFont.Weight = .semibold) -> UIButton {
        let button = UIButton(type: .system)
        button.configuration = configuration
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)]
        let attributedTitle = NSAttributedString(string: title, attributes: attribute)
        button.setAttributedTitle(attributedTitle, for: [])
        
        return button
    }
}
